//
//  OpenChatFileMessageTableViewCell.m
//  MyMessenger
//
//  Created by Jed Gyeong on 12/7/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import "OpenChatFileMessageTableViewCell.h"
#import "MyUtils.h"

@implementation OpenChatFileMessageTableViewCell {
    SendBirdFileLink *message;
    BOOL lightTheme;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.fileImageView.layer setBorderColor:[[UIColor purpleColor] CGColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFileMessage:(SendBirdFileLink *)msg
{
    message = msg;
    
    [self.nicknameLabel setAttributedText:[self buildMessage]];
    [self setFileImage:[[message fileInfo] url]];
}

- (NSAttributedString *) buildMessage
{
    NSString *nicknameBody = [NSString stringWithFormat:@"%@:", [message getSenderName]];
    NSDictionary *messageBodyAttribute;
    if (lightTheme) {
        messageBodyAttribute = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                 };
    }
    else {
        messageBodyAttribute = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                 NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                                 };
    }
    
    NSRange nicknameBodyRange = NSMakeRange(0, [nicknameBody length] - 1);
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:nicknameBody];
    [attributedMessage beginEditing];
    [attributedMessage setAttributes:messageBodyAttribute range:nicknameBodyRange];
    [attributedMessage endEditing];
    
    return attributedMessage;
}

- (void)setFileImage:(NSString *)imageUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Jios/%@", [SendBird VERSION]] forHTTPHeaderField:@"User-Agent"];
    [request setURL:[NSURL URLWithString:imageUrl]];
    
    [self.fileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        CGSize newSize = CGSizeMake([self.fileImageViewHeight constant] * 4 , [self.fileImageViewWidth constant] * 4);
        float widthRatio = newSize.width/image.size.width;
        float heightRatio = newSize.height/image.size.height;
        
        if(widthRatio > heightRatio) {
            newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
        }
        else {
            newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.fileImageView setImage:newImage];
    } failure:nil];
}

- (void)setTheme:(BOOL)th
{
    lightTheme = th;
}

- (CGFloat) getCellHeight
{
    CGFloat totalWidth = self.contentView.frame.size.width;
    
    NSAttributedString *attributedMessage = [self buildMessage];
    CGFloat messageWidth = totalWidth - ([self.rightMargin constant] + [self.leftMargin constant]);
    CGRect messageRect = [attributedMessage boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return messageRect.size.height + self.topMargin.constant + self.bottomMargin.constant + self.nicknameFileImageGap.constant + self.fileImageViewHeight.constant;
}

@end
