//
//  SignUpViewController.h
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpViewControllerDelegate<NSObject>

@optional
- (void)refreshSignUpStatus;

@end

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nullable, nonatomic, weak) id <SignUpViewControllerDelegate> delegate;

@end
