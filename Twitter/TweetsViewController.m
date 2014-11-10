//
//  TweetsViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController ()<UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property NSArray * tweets;
@property (nonatomic) TweetCell* prototypeCell;
@property UIRefreshControl *refreshControl;
@property MenuViewController * menuVC;

@end

@implementation TweetsViewController
- (IBAction)onEditBegin:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)onSwipe:(UIPanGestureRecognizer *)sender {
    [self.view addSubview:self.menuVC.view];

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // TODO: make a menu button that bounces when you start swiping, also allow menu button to be tapped to open menu
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([sender translationInView:self.view].x > 0) {
            [self.menuVC toggleMenu:YES];
        }
        else if ([sender translationInView:self.view].x < 0) {
            [self.menuVC toggleMenu:NO];
        }
        
    }
}

- (void) onTapProfileImage:(User *) user
{
    ProfileViewController * pvc = [[ProfileViewController alloc] initWithUser:user];
    
    [self.navigationController pushViewController:pvc animated:YES];
}


- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up hamburger menu off-screen
    self.menuVC = [[MenuViewController alloc] initWithCallingViewController:self];
    
    // table view setup
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    [self.tweetTableView registerNib: [UINib nibWithNibName:@"TweetCell" bundle: nil]
         forCellReuseIdentifier:@"TweetCell"];
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.refreshControl atIndex:0];

    // logout and compose buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onEditBegin:)];
    
    // register for notifications when a new tweet is composed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewTweet:) name:@"NewTweet" object:nil];
    
    // in case someone forgot to initialize it
    if (self.timelineSelector == nil)
    {
        self.timelineSelector = @selector(homeTimelineWithParams:completion:);
    }
    
        
    self.title = @"Home";
    
    [self reloadData];
}

- (void) onNewTweet:(NSNotification *) notification {
    NSDictionary * dictionary = notification.userInfo;
    Tweet * tweet = [dictionary objectForKey:@"tweet"];

    NSMutableArray * array = [NSMutableArray array];
    [array addObject: tweet];
    [array addObjectsFromArray:self.tweets];
    
    self.tweets = array;
    [self.tweetTableView reloadData];
}

- (void) reloadData {
    [[TwitterClient sharedInstance] performSelector:self.timelineSelector withObject:nil withObject:[^(NSArray *tweets, NSError *error){
        self.tweets = tweets;
        [self.tweetTableView reloadData];
    
    } copy]];
    
    [self.refreshControl endRefreshing];
}

// implement infinite scrolling
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // we have a bug where if we have fewer tweets than what's on the screen, it repeatedly tries to fetch more
    if (indexPath.row == self.tweets.count - 1 && indexPath.row > 5)
    {
        Tweet* oldestTweet = self.tweets[indexPath.row];
        NSNumber * tweetId = [NSNumber numberWithLong:oldestTweet.tweetId];
        
        NSDictionary * params = [NSDictionary dictionaryWithObject:tweetId forKey:@"max_id"];
        [[TwitterClient sharedInstance] performSelector:self.timelineSelector withObject:params withObject:[^(NSArray *tweets, NSError *error){

            NSMutableArray * array = [NSMutableArray array];
            [array addObjectsFromArray:self.tweets];
            [array addObjectsFromArray:tweets];
            self.tweets = array;

            [self.tweetTableView reloadData];
        } copy]];
        
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [[TweetCell alloc] init];
    cell = [self.tweetTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (TweetCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.tweetTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    
    return _prototypeCell;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetViewController * tvc = [[TweetViewController alloc] init];
    tvc.tweet = self.tweets[indexPath.row];

    [self.navigationController pushViewController:tvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
