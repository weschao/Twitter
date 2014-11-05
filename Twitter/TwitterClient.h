//
//  TwitterClient.h
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^) (User *user, NSError *error))completion;
- (void) openURL:(NSURL *) url;

- (void) mentionsTimelineWithParams:(NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error)) completion;
- (void) homeTimelineWithParams:(NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error)) completion;

- (void) favoriteTweetWithId:(long)tweetId completion:(void (^)(Tweet *, NSError *))completion;
- (void) unFavoriteTweetWithId:(long)tweetId completion:(void (^)(Tweet *, NSError *))completion;

- (void) retweetWithId:(long)tweetId completion:(void (^)(Tweet *, NSError *))completion;
- (void) undoRetweetWithId:(long)tweetId completion:(void (^)(NSError *))completion;

- (void) detailsForTweet:(long) tweetId completion:(void (^)(Tweet *, NSError *))completion;

- (void) postUpdate: (NSString *) update completion:(void (^)(Tweet *tweet, NSError *error)) completion;
- (void) postUpdateWithParams: (NSDictionary *) params completion:(void (^)(Tweet *tweet, NSError *error)) completion;

@end
