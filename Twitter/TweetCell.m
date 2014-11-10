//
//  TweetCell.m
//  Twitter
//
//  Created by Wes Chao on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "TTTAttributedLabel.h"

@interface TweetCell()<TTTAttributedLabelDelegate>

@end

@implementation TweetCell


- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // allow tapping on the profile picture
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    [self.profileImageView addGestureRecognizer:tapGR];
}
- (IBAction)onTapImage:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(onTapProfileImage:)])
        [self.delegate onTapProfileImage:self.tweet.author];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setTweet:(Tweet*) tweet {
    _tweet = tweet;
    
    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.author.profileImageUrl]];
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    [self.profileImageView addGestureRecognizer:tapGR];
    
    self.timestampLabel.text = tweet.createdAt.timeAgoSinceNow;
    self.usernameLabel.text = tweet.author.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.author.screenName];

    self.tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.tweetLabel.text = tweet.text;
    self.tweetLabel.delegate = self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}
@end
