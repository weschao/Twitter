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
#import "ProfileViewController.h"

@interface TweetViewController ()<TTTAttributedLabelDelegate>

@end


@implementation TweetViewController
- (IBAction)onTapProfileImage:(id)sender {
    ProfileViewController * pvc = [[ProfileViewController alloc] initWithUser:self.tweet.author];
    
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)onReplyButton:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    vc.initialText = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    vc.replyToId = self.tweet.tweetId;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)onFavoriteButton:(id)sender {
    if (self.tweet.favorited)
    {
        [[TwitterClient sharedInstance] unFavoriteTweetWithId:self.tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
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
        [[TwitterClient sharedInstance] favoriteTweetWithId:self.tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
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
    if (self.tweet.retweeted)
    {
        [[TwitterClient sharedInstance] undoRetweetWithId:self.tweet.tweetId completion:^(NSError *error) {
            if (! error)
            {
                // need to set these manually since the API does not return the parent tweet
                self.tweet.retweetId = 0;
                self.tweet.retweetCount -= 1;
                self.tweet.retweeted = NO;
                
                [self updateFavoriteLabel];
                [self.retweetButton setImage:[UIImage imageNamed:@"RetweetIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        [[TwitterClient sharedInstance] retweetWithId:self.tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
            if (tweet)
            {
                // need to set these manually since the API returns the retweet, and not the original tweet
                self.tweet.retweetId = tweet.tweetId;
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;

                [self updateFavoriteLabel];
                [self.retweetButton setImage:[UIImage imageNamed:@"RetweetOnIcon"] forState:UIControlStateNormal];
            }
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.author.profileImageUrl]];
    
    self.createdAtLabel.text = self.tweet.createdAt.timeAgoSinceNow;
    self.nameLabel.text = self.tweet.author.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];
    self.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.tweetTextLabel.text = self.tweet.text;
    self.tweetTextLabel.delegate = self;

    [self updateFavoriteLabel];
    
    if (self.tweet.favorited)
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteOnIcon"] forState:UIControlStateNormal];
    if (self.tweet.retweeted)
        [self.retweetButton setImage:[UIImage imageNamed:@"RetweetOnIcon"] forState:UIControlStateNormal];

    self.title = @"Tweet";
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}


- (void) updateFavoriteLabel
{
    NSString * retweetDescriptor = (self.tweet.retweetCount == 1) ? @"Retweet" : @"Retweets";
    
    NSString * favoriteDescriptor = (self.tweet.favoriteCount == 1) ? @"Favorite" : @"Favorites";
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d %@ %d %@", self.tweet.retweetCount, retweetDescriptor, self.tweet.favoriteCount, favoriteDescriptor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
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
