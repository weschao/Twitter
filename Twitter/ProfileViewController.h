//
//  ProfileViewController.h
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UIView *tweetsLabelView;
@property (weak, nonatomic) IBOutlet UIView *followersLabelView;
@property (weak, nonatomic) IBOutlet UIView *followingLabelView;
@property User * user;
@property (weak, nonatomic) IBOutlet UIView *demoView;

- (ProfileViewController *) initWithUser:(User *) user;

@end
