//
//  Server.m
//  Chatube
//
//  Created by Jed Kyung on 1/17/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "Server.h"
#import "MyUtils.h"
#import "Video.h"

#define HOST @"https://YOUR_GAE_PROJECT_ID.appspot.com"

#define kApiSignup @"/signup"
#define kApiSignIn @"/signin"
#define kApiRegisterVideo @"/video/register"
#define kApiVideoList @"/video/list"
#define kApiUpdateNickname @"/user/nickname"
#define kApiViewVideo @"/video/view"

@implementation Server

+ (void) signUpWithEmail:(NSString *)email nickname:(NSString *)nickname password:(NSString *)password deviceToken:(NSString *)deviceToken resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:email forKey:@"email"];
    [form setObject:nickname forKey:@"nickname"];
    [form setObject:password forKey:@"password"];
    [form setObject:deviceToken forKey:@"device_token"];
    [form setObject:@"IOS" forKey:@"device_type"];
    [self post:kApiSignup form:form resultBlock:onResult];
}

+ (void) loginWithEmail:(NSString *)email password:(NSString *)password deviceToken:(NSString *)deviceToken resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:email forKey:@"email"];
    [form setObject:password forKey:@"password"];
    [form setObject:deviceToken forKey:@"device_token"];
    [form setObject:@"IOS" forKey:@"device_type"];
    [self post:kApiSignIn form:form resultBlock:onResult];
}

+ (void) registerVideoWithURL:(NSString *)url videoId:(NSString *)videoId title:(NSString *)title thumbnail:(NSString *)thumbnail resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:[MyUtils getSession] forKey:@"session"];
    [form setObject:url forKey:@"url"];
    [form setObject:videoId forKey:@"video_id"];
    [form setObject:title forKey:@"title"];
    [form setObject:thumbnail forKey:@"thumbnail"];
    [self post:kApiRegisterVideo form:form resultBlock:onResult];
}

+ (void) queryVideoListOffset:(long long)offset limit:(long long)limit orderBy:(int)orderBy resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:[NSNumber numberWithLongLong:offset] forKey:@"offset"];
    [form setObject:[NSNumber numberWithLongLong:limit] forKey:@"limit"];
    // 1: Popular
    // 2: Created at
    [form setObject:[NSNumber numberWithInt:orderBy] forKey:@"order_by"];
    [self post:kApiVideoList form:form resultBlock:onResult];
}

+ (void) updateNickname:(NSString *)nickname resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:[MyUtils getSession] forKey:@"session"];
    [form setObject:nickname forKey:@"nickname"];
    [self post:kApiUpdateNickname form:form resultBlock:onResult];
}

+ (void) viewVideo:(NSString *)videoId
{
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:videoId forKey:@"video_id"];
    [self post:kApiViewVideo form:form resultBlock:nil];
}

+ (void) runWithRequest:(NSURLRequest *)request resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *jsonError;
        NSString *result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        NSError *error = nil;
        if (connectionError) {
            error = connectionError;
        }
        if (jsonError) {
            error = jsonError;
        }
        
        NSBlockOperation *op = [[NSBlockOperation alloc] init];
        [op addExecutionBlock:^{
            if (onResult) {
                onResult(dictResult, error);
            }
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
    }];
}

+ (void) getYouTubeInfoUrl:(NSString *)url resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"SendBird Messenger/0.9.0" forHTTPHeaderField:@"User-Agent"];
    [request setURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *videoId = @"";
        NSString *thumbnailUrl = @"";
        NSString *name = @"";
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        
        NSError *error = nil;
        if (connectionError) {
            error = connectionError;
            [result setObject:@"error" forKey:@"result"];
            [result setObject:@"message" forKey:@"Connection error."];
        }
        else {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
            TFHppleElement *videoIdelements = [doc peekAtSearchWithXPathQuery:@"//meta[@itemprop='videoId']"];
            TFHppleElement *thumbnailUrlElements = [doc peekAtSearchWithXPathQuery:@"//link[@itemprop='thumbnailUrl']"];
            TFHppleElement *nameIdelements = [doc peekAtSearchWithXPathQuery:@"//meta[@itemprop='name']"];
            videoId = [videoIdelements objectForKey:@"content"];
            thumbnailUrl = [thumbnailUrlElements objectForKey:@"href"];
            name = [nameIdelements objectForKey:@"content"];
            
            [result setObject:@"success" forKey:@"result"];
            [result setObject:videoId forKey:@"videoId"];
            [result setObject:thumbnailUrl forKey:@"thumbnailUrl"];
            [result setObject:name forKey:@"name"];
        }

        NSBlockOperation *op = [[NSBlockOperation alloc] init];
        [op addExecutionBlock:^{
            onResult(result, error);
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
    }];
}

+ (void) get:(NSString *)uri delegateAPIEventHandlerResultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:uri]];
    [request setValue:@"SendBird Messenger/0.9.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST, uri]]];
    
    [self runWithRequest:request resultBlock:onResult];
}

+ (void) post:(NSString *)uri form:(NSMutableDictionary *)form resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:uri]];
    [request setValue:@"SendBird Messenger/0.9.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST, uri]]];
    NSString *jsonBody = [MyUtils jsonStringWithPrettyPrint:YES fromDictionary:form];
    [request setHTTPBody:[jsonBody dataUsingEncoding:NSUTF8StringEncoding]];
    [self runWithRequest:request resultBlock:onResult];
}

@end
