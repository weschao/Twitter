//
//  Tweet.m
//  Twitter
//
//  Created by Wes Chao on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
    
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = (BOOL) [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = (BOOL) [dictionary[@"retweeted"] boolValue];
        self.createdAt = [formatter dateFromString:createdAtString];
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];

        self.tweetId = [dictionary[@"id"] longValue];
                
//        NSLog(@"%@", [dictionary valueForKeyPath:@"current_user_retweet"]);
//        NSLog(@"%@", [dictionary valueForKeyPath:@"current_user_retweet.id_str"]);
        self.retweetId = [[dictionary valueForKeyPath:@"current_user_retweet.id"] longValue];
    }
    
    return self;
   
}

+ (NSArray *) tweetsWithArray:(NSArray *) array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary * dictionary in array) {
        Tweet * tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    
    return tweets;
}
@end
