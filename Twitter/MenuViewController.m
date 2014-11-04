//
//  MenuViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"

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

    // set up off screen
    self.view.frame = CGRectMake(-150.0f, 48.0f, 150.0f, 200.0f);

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
            cell.textLabel.text = @"Home";
            break;
        case 1:
            cell.textLabel.text = @"Profile";
            break;
        case 2:
            cell.textLabel.text = @"Mentions";
    }
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            // Load the home timeline
        case 1:
        {
            // Load the user's profile
            ProfileViewController * pvc = [[ProfileViewController alloc] initWithUser:[User currentUser]];
            
            [self.callingViewController.navigationController pushViewController:pvc animated:YES];
        }
        case 2:
            // Load the mentions view
            break;
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
