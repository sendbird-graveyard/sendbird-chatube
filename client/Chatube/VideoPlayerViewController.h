//
//  VideoPlayerViewController.h
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SendBirdSDK/SendBirdSDK.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "YTPlayerView.h"
#import "Video.h"
#import "OpenChatMessageTableViewCell.h"
#import "OpenChatBroadcastTableViewCell.h"
#import "OpenChatFileMessageTableViewCell.h"

@interface VideoPlayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (strong, atomic) Video *video;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopMargin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UIButton *sendFileButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomMargin;
@property (weak, nonatomic) IBOutlet UIButton *closeKeyboardButton;

-(void) setVideoData:(Video *)video;

@end
