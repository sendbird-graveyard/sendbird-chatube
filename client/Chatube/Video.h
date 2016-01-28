//
//  Video.h
//  Chatube
//
//  Created by Jed Kyung on 1/18/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property NSString *url;
@property NSString *videoID;
@property NSString *title;
@property NSString *thumbnail;
@property NSString *owner;
@property long long createdTime;
@property NSString *channelUrl;
@property long long viewer;

- (id) initWithDic:(NSDictionary *) dic;

@end
