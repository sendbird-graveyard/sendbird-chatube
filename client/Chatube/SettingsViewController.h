//
//  SettingsViewController.h
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface SettingsViewController : UIViewController<SignInViewControllerDelegate, SignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signOutButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleText;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIView *signedOutView;
@property (weak, nonatomic) IBOutlet UIView *signedInView;


- (void)setData;
- (void)setLoginStatus;

@end
