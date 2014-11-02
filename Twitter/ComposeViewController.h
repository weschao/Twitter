//
//  ComposeViewController.h
//  Twitter
//
//  Created by Wes Chao on 11/2/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property long replyToId;
@property NSString *initialText;
@end
