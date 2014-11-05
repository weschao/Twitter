//
//  TweetsViewController.h
//  Twitter
//
//  Created by Wes Chao on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property SEL timelineSelector;

@end
