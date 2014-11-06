//
//  User.m
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property NSDictionary* dictionary;
@end

@implementation User

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.bannerImageUrl = dictionary[@"profile_banner_url"];

        self.tagline = [self sanitizedStringWithString:dictionary[@"description"]];
        self.location = [self sanitizedStringWithString:dictionary[@"location"]];
        self.url = [self sanitizedStringWithString:dictionary[@"url"]];
        
        self.tweets = [dictionary[@"statuses_count"] longValue];
        self.followers = [dictionary[@"followers_count"] longValue];
        self.following = [dictionary[@"friends_count"] longValue];
        
//        NSLog(@"%@", dictionary);
    }

    return self;
}

- (NSString *) sanitizedStringWithString:(NSObject *) string {
    if (string == nil || string == [NSNull null])
        return @"";
    else
        return string;
}

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *) currentUser {
    if  (_currentUser == nil) {

            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void) setCurrentUser:(User *)user {
    _currentUser = user;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void) logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
