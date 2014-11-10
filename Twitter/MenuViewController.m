//
//  MenuViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property BOOL displayingMenu;
@end

@implementation MenuViewController

- (id) initWithCallingViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
        self.callingViewController = viewController;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;

    // set up off screen hamburger menu
    self.view.frame = CGRectMake(-150.0f, 48.0f, 150.0f, 133.0f);

    // set background color
    UIColor * blueColor = [UIColor colorWithRed:84.0/255.0f green:172.0/255.0f blue:238.0/255.0f alpha:1];
    self.menuTableView.backgroundColor = blueColor;
    
    [self.menuTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) toggleMenu:(BOOL) display
{
    if (!self.displayingMenu && display)
    {
        self.displayingMenu = YES;
        [self moveMenuByPixels: 150];
    }
    else if (self.displayingMenu && !display)
    {
        self.displayingMenu = NO;
        [self moveMenuByPixels: -150];
    }
    
}

- (void) moveMenuByPixels:(int) pixels
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect menuFrame = self.view.frame;
        menuFrame.origin.x += pixels;
        
        self.view.frame = menuFrame;
    }];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] init];

    switch (indexPath.row)
    {
        case 0:
            // makes the separator too short
            [cell.imageView setImageWithURL:[NSURL URLWithString: [User currentUser].profileImageUrl]];
            cell.textLabel.text = [User currentUser].name;
            break;
        case 1:
            cell.textLabel.text = @"Home";
            break;
        case 2:
            cell.textLabel.text = @"Mentions";
    }
    
    UIColor * blueColor = [UIColor colorWithRed:84.0/255.0f green:172.0/255.0f blue:238.0/255.0f alpha:1];
    cell.backgroundColor = blueColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            // Load the user's profile
            ProfileViewController * pvc = [[ProfileViewController alloc] initWithUser:[User currentUser]];
            
            [self.callingViewController.navigationController pushViewController:pvc animated:YES];
            break;
        }
        case 1:
        {
            // Load the home timeline
            TweetsViewController * tvc = [[TweetsViewController alloc] init];
            tvc.timelineSelector = @selector(homeTimelineWithParams:completion:);
            
            [self.callingViewController.navigationController pushViewController:tvc animated:YES];
            
            break;
        }
        case 2:
        {
            // Load the mentions view
            TweetsViewController * tvc = [[TweetsViewController alloc] init];
            tvc.timelineSelector = @selector(mentionsTimelineWithParams:completion:);
            
            [self.callingViewController.navigationController pushViewController:tvc animated:YES];
            break;
        }
    }
    [self toggleMenu:NO];
    
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
