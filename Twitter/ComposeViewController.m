//
//  ComposeViewController.m
//  Twitter
//
//  Created by Wes Chao on 11/2/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()<UITextViewDelegate>

@end

@implementation ComposeViewController

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (! self.initialText)
        self.tweetTextView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%d", 140 - self.tweetTextView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [self.tweetTextView.text length] + [text length] - range.length;
    return (newLength > 140) ? NO : YES;
}

- (IBAction)onTweet:(id)sender {
    
    NSString * update = self.tweetTextView.text;
    
    [[TwitterClient sharedInstance] postUpdate:update completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"%@", tweet.text);
        [self dismissViewControllerAnimated:YES completion:nil];

    }];

}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * profileUrl = [NSURL URLWithString:[User currentUser].profileImageUrl];
    [self.profileImageView setImageWithURL:profileUrl];
    
    self.usernameLabel.text = [User currentUser].name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].screenName];

    self.tweetTextView.delegate = self;

    if (self.initialText)
        self.tweetTextView.text = self.initialText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
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
