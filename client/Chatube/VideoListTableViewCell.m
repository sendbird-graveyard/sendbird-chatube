//
//  OpenChatChannelListTableViewCell.m
//  MyMessenger
//
//  Created by Jed Gyeong on 12/4/15.
//  Copyright © 2015 SENDBIRD.COM. All rights reserved.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell {
    Video *video;
}

- (void)awakeFromNib {
    // Initialization code
    
//    self.thumbnailImageView.layer.cornerRadius = 4;
//    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageViewHeight.constant / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThumbnailImage:(NSString *)imageUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Jios/%@", [SendBird VERSION]] forHTTPHeaderField:@"User-Agent"];
    [request setURL:[NSURL URLWithString:imageUrl]];
    
    [self.thumbnailImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        CGSize newSize = CGSizeMake([self.thumbnailImageViewHeight constant] * 4 , [self.thumbnailImageViewWidth constant] * 4);
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
        
        [self.thumbnailImageView setImage:newImage];
    } failure:nil];
}

- (void)setTitle:(NSString *)topic
{
    [self.titleLabel setText:topic];
}

- (void)setOwner:(NSString *)owner
{
    [self.ownerLabel setText:owner];
}

- (void)setVideo:(Video *)v
{
    video = v;
    if ([video.thumbnail length] > 0) {
        [self setThumbnailImage:video.thumbnail];
    }
    [self setTitle:video.title];
    [self setOwner:[NSString stringWithFormat:@"by %@", video.owner]];
}

@end
