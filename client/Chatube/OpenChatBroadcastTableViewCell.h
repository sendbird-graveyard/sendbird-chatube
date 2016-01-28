//
//  OpenChatBroadcastTableViewCell.h
//  MyMessenger
//
//  Created by Jed Gyeong on 12/4/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SendBirdSDK/SendBirdSDK.h>

@interface OpenChatBroadcastTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *broadcastTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *broadcastRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *broadcastLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *broadcastBottomMargin;
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;

- (void)setBroadcastMessage:(SendBirdBroadcastMessage *)msg;
- (CGFloat) getCellHeight;

@end
