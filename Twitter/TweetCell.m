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

@interface User()

@property Tweet* _tweet;
@end

@implementation TweetCell


- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


Tweet *_tweet = nil;

- (void) setTweet:(Tweet*) tweet {
    _tweet = tweet;
    
    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.author.profileImageUrl]];
    
    self.timestampLabel.text = tweet.createdAt.timeAgoSinceNow;
    self.usernameLabel.text = tweet.author.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.author.screenName];
    self.tweetTextLabel.text = tweet.text;
    
}
@end
