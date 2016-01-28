//
//  Video.m
//  Chatube
//
//  Created by Jed Kyung on 1/18/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "Video.h"

@implementation Video

- (id) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic objectForKey:@"url"] != nil && ![[dic objectForKey:@"url"] isKindOfClass:[NSNull class]]) {
            self.url = [dic objectForKey:@"url"];
        }
        
        if ([dic objectForKey:@"video_id"] != nil && ![[dic objectForKey:@"video_id"] isKindOfClass:[NSNull class]]) {
            self.videoID = [dic objectForKey:@"video_id"];
        }
        
        if ([dic objectForKey:@"title"] != nil && ![[dic objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
            self.title = [dic objectForKey:@"title"];
        }
        
        if ([dic objectForKey:@"thumbnail"] != nil && ![[dic objectForKey:@"thumbnail"] isKindOfClass:[NSNull class]]) {
            self.thumbnail = [dic objectForKey:@"thumbnail"];
        }
        
        if ([dic objectForKey:@"owner"] != nil && ![[dic objectForKey:@"owner"] isKindOfClass:[NSNull class]]) {
            self.owner = [dic objectForKey:@"owner"];
        }
        
        if ([dic valueForKey:@"createdTime"] != nil && ![[dic valueForKey:@"createdTime"] isKindOfClass:[NSNull class]]) {
            self.createdTime = [[dic valueForKey:@"createdTime"] longLongValue];
        }
        
        if ([dic objectForKey:@"channel_url"] != nil && ![[dic objectForKey:@"channel_url"] isKindOfClass:[NSNull class]]) {
            self.channelUrl = [dic objectForKey:@"channel_url"];
        }
        
        if ([dic valueForKey:@"viewer"] != nil && ![[dic valueForKey:@"viewer"] isKindOfClass:[NSNull class]]) {
            self.viewer = [[dic valueForKey:@"viewer"] longLongValue];
        }
    }
    return self;
}

@end
