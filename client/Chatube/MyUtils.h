//
//  MyUtils.h
//  MyMessenger
//
//  Created by Jed Gyeong on 12/6/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SendBirdSDK/SendBirdSDK.h>

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

@interface MyUtils : NSObject

+ (NSString *) lastMessageDateTime:(NSTimeInterval) interval;
+ (void) setUserID:(NSString *)userID;
+ (NSString *) getUserID;
+ (void) setSendBirdID:(NSString *)sendBirdID;
+ (NSString *) getSendBirdID;
+ (void) setUserName:(NSString *)userName;
+ (NSString *) getUserName;
+ (void) setUserProfileImage:(NSString *)profileImageUrl;
+ (NSString *) getUserProfileImage;
+ (NSString *)generateMessagingTitle:(SendBirdMessagingChannel *)channel;
+ (NSString *)generateMessagingChannelTitle:(SendBirdMessagingChannel *)channel;
+ (NSString *)generateTypingStatus:(NSMutableDictionary *)typeStatus;
+ (NSString *) jsonStringWithPrettyPrint:(BOOL) prettyPrint fromDictionary:(NSDictionary *)dic;
+ (NSString *) getSession;
+ (void) setSession:(NSString *)session;
+ (UIImage *)imageFromColor:(UIColor *)color;

@end
