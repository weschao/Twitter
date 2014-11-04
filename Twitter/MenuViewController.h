//
//  MenuViewController.h
//  Twitter
//
//  Created by Wes Chao on 11/4/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property UIViewController * callingViewController;

- (id) initWithCallingViewController: (UIViewController *) viewController;

- (void) toggleMenu:(BOOL) display;

@end

