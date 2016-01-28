//
//  ChatubeButton.m
//  Chatube
//
//  Created by Jed Kyung on 1/16/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "ChatubeButton.h"

@implementation ChatubeButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self setBackgroundImage:[UIImage imageNamed:@"default_btn_normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"default_btn_pressed"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"default_btn_pressed"] forState:UIControlStateHighlighted];
//
//    [[self titleLabel] setTextColor:[UIColor whiteColor]];
}

@end
