//
//  OpenChatChannelListTableViewCell.h
//  MyMessenger
//
//  Created by Jed Gyeong on 12/4/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <SendBirdSDK/SendBirdSDK.h>

#import "Video.h"

@interface VideoListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;

- (void)setVideo:(Video *)v;

@end
