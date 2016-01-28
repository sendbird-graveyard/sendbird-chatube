//
//  RegisterVideoViewController.h
//  Chatube
//
//  Created by Jed Kyung on 1/17/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterVideoViewControllerDelegate<NSObject>

@optional
- (void)refreshPopularVideoView;
- (void)refreshNewVideoView;

@end

@interface RegisterVideoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *videoUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UIView *pageTwoView;
@property (weak, nonatomic) IBOutlet UIView *pageOneView;
@property (strong, nonatomic) UIButton *nextButton;

@property (nonatomic, weak) id <RegisterVideoViewControllerDelegate> delegate;

@property NSString *url;
@property NSString *videoId;
@property NSString *name;
@property NSString *thumbnailUrl;

@end
