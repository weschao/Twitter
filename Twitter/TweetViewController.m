//
//  TweetViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/2/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetViewController ()

// TODO: I tried naming this _tweet, but I got a compiler error: duplicate variables in TweetCell.m and this class.
@property Tweet* _mTweet;
@end


@implementation TweetViewController
- (IBAction)onReplyButton:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    vc.initialText = [NSString stringWithFormat:@"@%@", _mTweet.author.screenName];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)onFavoriteButton:(id)sender {
    if (_mTweet.favorited)
    {
        [[TwitterClient sharedInstance] unFavoriteTweetWithId:_mTweet.tweetId completion:^(Tweet *tweet, NSError *error) {

            NSLog(@"%d %d", tweet.favorited, tweet.favoriteCount);
            if (tweet)
            {
                self.tweet = tweet;
                [self updateFavoriteLabel];
                [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        [[TwitterClient sharedInstance] favoriteTweetWithId:_mTweet.tweetId completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"%d %d", tweet.favorited, tweet.favoriteCount);
            if (tweet)
            {
                self.tweet = tweet;
                [self updateFavoriteLabel];
                [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteOnIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    
}

- (IBAction)onRetweetButton:(id)sender {
    if (_mTweet.retweeted)
    {
        [[TwitterClient sharedInstance] undoRetweetWithId:_mTweet.tweetId completion:^(NSError *error) {
            NSLog(@"unretweeted!");
            if (! error)
            {
                [self.retweetButton setImage:[UIImage imageNamed:@"RetweetIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        [[TwitterClient sharedInstance] retweetWithId:_mTweet.tweetId completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"retweeted: %d", tweet.retweeted);
            if (tweet)
            {
                self.tweet = tweet;
                [self.retweetButton setImage:[UIImage imageNamed:@"RetweetOnIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:_mTweet.author.profileImageUrl]];
    
    self.createdAtLabel.text = _mTweet.createdAt.timeAgoSinceNow;
    self.nameLabel.text = _mTweet.author.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", _mTweet.author.screenName];
    self.tweetTextLabel.text = _mTweet.text;
    
    [self updateFavoriteLabel];
    
    if (_mTweet.favorited)
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteOnIcon"] forState:UIControlStateNormal];
    if (_mTweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"RetweetOnIcon"] forState:UIControlStateNormal];

}

- (void) updateFavoriteLabel
{
    NSString * favoriteDescriptor = (_mTweet.favoriteCount == 1) ? @"Favorite" : @"Favorites";
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d %@", _mTweet.favoriteCount, favoriteDescriptor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


Tweet *_mTweet = nil;

- (void) setTweet:(Tweet*) tweet {
    _mTweet = tweet;
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
