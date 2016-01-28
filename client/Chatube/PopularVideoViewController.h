//
//  FirstViewController.h
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "RegisterVideoViewController.h"
#import "MyUtils.h"
#import "Server.h"
#import "VideoListTableViewCell.h"
#import "Video.h"
#import "VideoPlayerViewController.h"

@interface PopularVideoViewController : UIViewController<YTPlayerViewDelegate, SignInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, RegisterVideoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginOutButton;

- (void)setLoginStatus;

@end

