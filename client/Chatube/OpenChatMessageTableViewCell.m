//
//  OpenChatMessageTableViewCell.m
//  MyMessenger
//
//  Created by Jed Gyeong on 12/4/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import "OpenChatMessageTableViewCell.h"
#import "MyUtils.h"

@implementation OpenChatMessageTableViewCell {
    SendBirdMessage *message;
    BOOL lightTheme;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.messageLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheme:(BOOL)th
{
    lightTheme = th;
}

- (void)setMessage:(SendBirdMessage *)msg {
    message = msg;
    
    [self.messageLabel setAttributedText:[self buildMessage]];
}

- (NSAttributedString *) buildMessage
{
    NSString *userName = [message getSenderName];
    NSString *messageBody = [message message];
    
    NSString *fullMessage = [NSString stringWithFormat:@"%@: %@", userName, messageBody];
    
    NSDictionary *userNameAttribute;
    NSDictionary *messageBodyAttribute;
    
    if (lightTheme) {
        userNameAttribute = @{
                              NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                              NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                              };
        messageBodyAttribute = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                 };
    }
    else {
        userNameAttribute = @{
                              NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                              NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                              };
        messageBodyAttribute = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                                 };
    }

    NSRange userNameRange = NSMakeRange(0, [userName length]);
    NSRange messageBodyRange = NSMakeRange([userName length] + 2, [messageBody length]);
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:fullMessage];
    [attributedMessage beginEditing];
    [attributedMessage setAttributes:userNameAttribute range:userNameRange];
    [attributedMessage setAttributes:messageBodyAttribute range:messageBodyRange];
    [attributedMessage endEditing];
    
    return attributedMessage;
}

- (CGFloat) getCellHeight
{
    CGFloat totalWidth = self.contentView.frame.size.width;
    
    NSAttributedString *attributedMessage = [self buildMessage];
    CGFloat messageWidth = totalWidth - ([self.messageLabelRightMargin constant] + [self.messageLabelLeftMargin constant]);
    CGRect messageRect = [attributedMessage boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return messageRect.size.height + self.messageLabelTopMargin.constant + self.messageLabelBottomMargin.constant + 1;
}

@end
