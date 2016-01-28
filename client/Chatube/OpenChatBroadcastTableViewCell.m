//
//  OpenChatBroadcastTableViewCell.m
//  MyMessenger
//
//  Created by Jed Gyeong on 12/4/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import "OpenChatBroadcastTableViewCell.h"
#import "MyUtils.h"

@implementation OpenChatBroadcastTableViewCell {
    SendBirdBroadcastMessage *message;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBroadcastMessage:(SendBirdBroadcastMessage *)msg {
    message = msg;
    
    [self.broadcastLabel setAttributedText:[self buildMessage]];
}

- (NSAttributedString *) buildMessage
{
    NSString *messageBody = [message message];
    NSDictionary *messageBodyAttribute = @{
                                        NSFontAttributeName:[UIFont systemFontOfSize:12],
                                        NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                        };
    
    NSRange messageBodyRange = NSMakeRange(0, [messageBody length]);
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:messageBody];
    [attributedMessage beginEditing];
    [attributedMessage setAttributes:messageBodyAttribute range:messageBodyRange];
    [attributedMessage endEditing];
    
    return attributedMessage;
}

- (CGFloat) getCellHeight
{
    CGFloat totalWidth = self.contentView.frame.size.width;
    
    NSAttributedString *attributedMessage = [self buildMessage];
    CGFloat messageWidth = totalWidth - ([self.broadcastRightMargin constant] + [self.broadcastLeftMargin constant]);
    CGRect messageRect = [attributedMessage boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return messageRect.size.height + self.broadcastTopMargin.constant + self.broadcastBottomMargin.constant;
}

@end
