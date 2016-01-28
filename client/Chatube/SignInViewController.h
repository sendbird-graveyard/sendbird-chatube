//
//  SignInViewController.h
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewControllerDelegate<NSObject>

- (void)openSignUpViewController;

@optional
- (void)refreshSignInStatus;

@end

@interface SignInViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (nullable, nonatomic, weak) id <SignInViewControllerDelegate> delegate;

@end
