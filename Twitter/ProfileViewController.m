//
//  ProfileViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()<UIScrollViewDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.photoView setImageWithURL:[NSURL URLWithString: self.user.bannerImageUrl]];
    [self.photoView setAlpha:0.6f];
    [self.view sendSubviewToBack: self.photoView];

    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.user.name;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.handleLabel.textColor = [UIColor whiteColor];
    
    // set the content size to be exactly two pages wide
    self.headerScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 2, self.headerScrollView.frame.size.height);
    
    // create a second page in the header to house additional information
    CGRect frame = self.headerScrollView.bounds;
    frame.origin.x += [[UIScreen mainScreen] bounds].size.width;
    UIView * view = [[UIView alloc] initWithFrame:frame];

    // programmatically create labels for the offscreen view (ugh this is tedious)
    NSLog(@"'%@', '%@', '%@'", self.user.tagline, self.user.location, self.user.url);
    
    if (! [self.user.tagline isEqualToString:@""])
    {
        UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 40, 300, 40)];
        descriptionLabel.text = self.user.tagline;
        descriptionLabel.font = [descriptionLabel.font fontWithSize:13];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:descriptionLabel];
    }
    
    if (! [self.user.location isEqualToString:@""])
    {
        UILabel * locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 80, 150, 20)];
        locationLabel.text = self.user.location;
        locationLabel.font = [locationLabel.font fontWithSize:12];
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:locationLabel];
    }
    
    if (! [self.user.url isEqualToString:@""])
    {
        UILabel * urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 100, 200, 20)];
        urlLabel.text = self.user.url;
        urlLabel.font = [urlLabel.font fontWithSize:12];
        urlLabel.textColor = [UIColor whiteColor];
        urlLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:urlLabel];
    }
    
    [self.headerScrollView addSubview:view];

    // set borders and counts
    self.tweetsLabelView.layer.borderColor = [UIColor grayColor].CGColor;
    self.tweetsLabelView.layer.borderWidth = 1.0f;
    self.tweetsLabel.text = [NSString stringWithFormat:@"%ld tweets", self.user.tweets];

    self.followersLabelView.layer.borderColor = [UIColor grayColor].CGColor;
    self.followersLabelView.layer.borderWidth = 1.0f;
    self.followersLabel.text = [NSString stringWithFormat:@"%ld followers", self.user.followers];
    
    self.followingLabelView.layer.borderColor = [UIColor grayColor].CGColor;
    self.followingLabelView.layer.borderWidth = 1.0f;
    self.followingLabel.text = [NSString stringWithFormat:@"%ld following", self.user.following];

    // do some effects on background image while scrolling
    self.headerScrollView.delegate = self;
    
    // add an effect when we pull down the profile page
    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPullDown:)];
    [self.view addGestureRecognizer:panGR];
}

- (void) onPullDown:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        float scale = 1 + [sender translationInView:self.view].y / self.view.bounds.size.height * 2;
        self.photoView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.photoView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // start at 0.6 alpha, fade up to 0.9 as we hit the second page
    [self.photoView setAlpha:0.6f + 0.3f * scrollView.contentOffset.x / [[UIScreen mainScreen] bounds].size.width];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int newOffset = scrollView.contentOffset.x;
    int newPage = (int)(newOffset/(scrollView.frame.size.width));
    [self.headerPageControl setCurrentPage:newPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ProfileViewController *) initWithUser:(User *) user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (BOOL) prefersStatusBarHidden{
    return YES;
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
