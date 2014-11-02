//
//  TwitterClient.m
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"FWMeLxs3VzGrB8QmBgjBtBc1c";
NSString * const kTwitterConsumerSecret = @"2lVR4F5jouyrN9vSkEQohIq0MWMNFOuoWx74T4hExr3zGGJw0G";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance{
    static TwitterClient * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^) (User *user, NSError *error))completion
{
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterapp://oauth"] scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSURL * authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                [[UIApplication sharedApplication] openURL: authURL];
                                                          
                            } failure:^(NSError *error) {
                                self.loginCompletion(nil, error);
                            }];

    
}

- (void) openURL:(NSURL *) url
{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                      success:^(BDBOAuthToken *accessToken) {
        
                          [self.requestSerializer saveAccessToken:accessToken];
                          [self GET:@"1.1/account/verify_credentials.json" parameters:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                [User setCurrentUser:user];
                                self.loginCompletion(user, nil);
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"failed to get current user");
                              self.loginCompletion(nil, error);
                          }];
        
                      }failure:^(NSError *error) {
                          NSLog(@"failed to open URL");
                      }];
}

- (void) homeTimelineWithParams:(NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error)) completion
{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion (tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void) favoriteTweetWithId:(long) tweetId completion:(void (^)(Tweet *, NSError *))completion
{
    NSDictionary * params = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:tweetId] forKey:@"id"];

    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion (tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        completion(nil, error);
    }];
    
}

- (void) unFavoriteTweetWithId:(long) tweetId completion:(void (^)(Tweet *, NSError *))completion
{
    NSDictionary * params = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:tweetId] forKey:@"id"];
    
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion (tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        completion(nil, error);
    }];
    
}

- (void) retweetWithId:(long)tweetId completion:(void (^)(Tweet *, NSError *))completion
{
    NSString * url = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweetId];
    
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion (tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        completion(nil, error);
    }];
}

// This code actually hurts my brain, it's so ugly.
- (void) undoRetweetWithId:(long)tweetId completion:(void (^)(NSError *))completion
{
    // get the details for the tweet, so that we have the retweet id
    [self detailsForTweet:tweetId completion:^(Tweet *tweet, NSError *error) {
        NSString * url = [NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", tweet.retweetId];
        
        [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {            
            completion (nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error);
            completion(error);
        }];

    }];
    
}


- (void) detailsForTweet:(long) tweetId completion:(void (^)(Tweet *, NSError *))completion
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithLong:tweetId], @"id",
                             @"true", @"include_my_retweet", nil];
    
    [self GET:@"1.1/statuses/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion (tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];

}

- (void) postUpdate:(NSString *)update completion:(void (^)(Tweet *, NSError *))completion
{
    NSDictionary * params = [NSDictionary dictionaryWithObject:update forKey:@"status"];
    [self postUpdateWithParams:params completion:completion];
}

- (void) postUpdateWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion
{
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion (tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        completion(nil, error);
    }];
}

@end
