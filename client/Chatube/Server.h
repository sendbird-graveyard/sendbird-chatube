//
//  Server.h
//  Chatube
//
//  Created by Jed Kyung on 1/17/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <hpple/TFHpple.h>

@interface Server : NSObject

+ (void) signUpWithEmail:(NSString *)email nickname:(NSString *)nickname password:(NSString *)password deviceToken:(NSString *)deviceToken resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) loginWithEmail:(NSString *)email password:(NSString *)password deviceToken:(NSString *)deviceToken resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) getYouTubeInfoUrl:(NSString *)url resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) registerVideoWithURL:(NSString *)url videoId:(NSString *)videoId title:(NSString *)title thumbnail:(NSString *)thumbnail resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) queryVideoListOffset:(long long)offset limit:(long long)limit orderBy:(int)orderBy resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) updateNickname:(NSString *)nickname resultBlock:(void (^)(NSDictionary *response, NSError *error))onResult;
+ (void) viewVideo:(NSString *)videoId;

@end
