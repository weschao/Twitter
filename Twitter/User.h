//
//  User.h
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSString *descriptionText;
@property (nonatomic) NSString *profileImageUrl;
@property (nonatomic) NSString *tagline;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *bannerImageUrl;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (User *) currentUser;
+ (void) setCurrentUser:(User *)user;
+ (void) logout;

@end
