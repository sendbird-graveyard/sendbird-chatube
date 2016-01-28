//
//  MyUtils.m
//  MyMessenger
//
//  Created by Jed Gyeong on 12/6/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import "MyUtils.h"

#define kKeyUserID @"chatube_user_id"
#define kKeySendBirdID @"chatube_sendbird_id"
#define kKeyUserName @"chatube_username"
#define kKeyUserPassword @"chatube_password"
#define kKeyUserProfileImageUrl @"chatube_profile_image_url"
#define kKeyUserSession @"chatube_session"

@implementation MyUtils

+ (NSString *) lastMessageDateTime:(NSTimeInterval) interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [formatter stringFromDate:date];
}

+ (void) setUserID:(NSString *)userID
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:userID forKey:kKeyUserID];
    [preferences synchronize];
}

+ (NSString *) getUserID
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *userID = @"";
    if ([preferences objectForKey:kKeyUserID] == nil) {
        userID = @"";
    }
    else {
        userID = (NSString *)[preferences objectForKey:kKeyUserID];
    }
    
    if ([userID length] == 0) {
        NSString *deviceId = [SendBird deviceUniqueID];
        userID = deviceId;
    }
    
    return userID;
}

+ (void) setSendBirdID:(NSString *)sendBirdID
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:sendBirdID forKey:kKeySendBirdID];
    [preferences synchronize];
}

+ (NSString *) getSendBirdID
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *userID = @"";
    if ([preferences objectForKey:kKeySendBirdID] == nil) {
        userID = nil;
    }
    else {
        userID = (NSString *)[preferences objectForKey:kKeySendBirdID];
    }

    return userID;
}

+ (void) setUserName:(NSString *)userName
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:userName forKey:kKeyUserName];
    [preferences synchronize];
}

+ (NSString *) getUserName
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *userName = @"";
    if ([preferences objectForKey:kKeyUserName] == nil) {
        userName = @"";
    }
    else {
        userName = (NSString *)[preferences objectForKey:kKeyUserName];
    }
    
    if ([userName length] == 0) {
        NSString *deviceId = [SendBird deviceUniqueID];
        userName = [NSString stringWithFormat:@"User-%@", [deviceId substringToIndex:5]];
    }
    
    return userName;
}

+ (void) setUserProfileImage:(NSString *)profileImageUrl
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:profileImageUrl forKey:kKeyUserProfileImageUrl];
    [preferences synchronize];
}

+ (NSString *) getUserProfileImage
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:kKeyUserProfileImageUrl] == nil) {
        [MyUtils setUserProfileImage:@"https://jiver.co/main/img/profiles/profile_01_512px.png"];
        return @"https://jiver.co/main/img/profiles/profile_01_512px.png";
    }
    else {
        return (NSString *)[preferences objectForKey:kKeyUserProfileImageUrl];
    }
}

+ (NSString *) getSession
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *session = @"";
    if ([preferences objectForKey:kKeyUserSession] == nil) {
        session = nil;
    }
    else {
        session = (NSString *)[preferences objectForKey:kKeyUserSession];
    }
    
    return session;
}

+ (void) setSession:(NSString *)session
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:session forKey:kKeyUserSession];
    [preferences synchronize];
}

+ (NSString *)generateMessagingTitle:(SendBirdMessagingChannel *)channel
{
    if ([[channel members] count] == 2) {
        NSString *title = @"";
        for (SendBirdMemberInMessagingChannel *member in [channel members]) {
            if (![[member guestId] isEqualToString:[SendBird getUserId]]) {
                title = [member name];
            }
        }
        return title;
    }
    else {
        return [NSString stringWithFormat:@"Group(%lu)", [[channel members] count]];
    }
}

+ (NSString *)generateMessagingChannelTitle:(SendBirdMessagingChannel *)channel
{
    if ([[channel members] count] == 2) {
        NSString *title = @"";
        for (SendBirdMemberInMessagingChannel *member in [channel members]) {
            if (![[member guestId] isEqualToString:[SendBird getUserId]]) {
                title = [member name];
            }
        }
        return title;
    }
    else {
        NSString *title = @"";
        NSMutableArray *names = [[NSMutableArray alloc] init];
        for (SendBirdMemberInMessagingChannel *member in [channel members]) {
            if (![[member guestId] isEqualToString:[SendBird getUserId]]) {
                [names addObject:[member name]];
            }
        }
        title = [names componentsJoinedByString:@", "];
        return title;
    }
}

+ (NSString *)generateTypingStatus:(NSMutableDictionary *)typeStatus
{
    NSArray *values = [typeStatus allKeys];
    
    return [NSString stringWithFormat:@"%lu Typing something cool...", [values count]];
}

+ (NSString *) jsonStringWithPrettyPrint:(BOOL) prettyPrint fromDictionary:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
