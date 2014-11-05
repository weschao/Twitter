//
//  ProfileViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.photoView setImageWithURL:[NSURL URLWithString: self.user.bannerImageUrl]];
    [self.photoView setAlpha:0.8f];
    [self.view sendSubviewToBack: self.photoView];

    // profile pic
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.user.name;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.handleLabel.textColor = [UIColor whiteColor];

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
