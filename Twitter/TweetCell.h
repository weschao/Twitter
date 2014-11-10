//
//  TweetCell.h
//  Twitter
//
//  Created by Wes Chao on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"

@protocol TweetCellDelegate <NSObject>

@optional
- (void) onTapProfileImage:(User *) user;
@end

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetLabel;

@property NSObject<TweetCellDelegate> * delegate;
@property (nonatomic) Tweet* tweet;

@end
