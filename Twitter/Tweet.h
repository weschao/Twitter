//
//  Tweet.h
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic) NSString *text;
@property (nonatomic) NSDate * createdAt;
@property (nonatomic) User * author;
@property (nonatomic) int favoriteCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) long tweetId;
@property (nonatomic) long retweetId;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *) tweetsWithArray:(NSArray *) array;
@end
