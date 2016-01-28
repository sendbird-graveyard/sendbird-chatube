//
//  SettingsViewController.m
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyUtils.h"
#import "Server.h"

#define TEXT_FIELD_LEFT_PADDING 12.0
#define TEXT_FIELD_RIGHT_PADDING 12.0

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.indicatorView setHidden:YES];
    [self.indicatorView stopAnimating];
    
    [self setLoginStatus];
    
    [self.signOutButton setTitleTextAttributes:@{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                 NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                                                 } forState:UIControlStateNormal];
    
    [self.nicknameTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_LEFT_PADDING, 20)]];
    [self.nicknameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.nicknameTextField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_RIGHT_PADDING, 20)]];
    [self.nicknameTextField setRightViewMode:UITextFieldViewModeAlways];
    
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"default_btn_normal"] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"default_btn_pressed"] forState:UIControlStateHighlighted];
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"default_btn_pressed"] forState:UIControlStateSelected];
    
    [self.signInButton setBackgroundImage:[UIImage imageNamed:@"btn_red_line_normal"] forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage imageNamed:@"btn_red_line_pressed"] forState:UIControlStateHighlighted];
    [self.signInButton setBackgroundImage:[UIImage imageNamed:@"btn_red_line_pressed"] forState:UIControlStateSelected];
    
    
    if ([MyUtils getSession] != nil && [[MyUtils getSession] length] > 0) {
        [self.nicknameTextField setText:[MyUtils getUserName]];
        [self.nicknameTextField setEnabled:YES];
        [self.signOutButton setEnabled:YES];
        [self.signOutButton setTitle:@"SIGN OUT"];
    }
    else {
        [self.nicknameTextField setText:@""];
        [self.nicknameTextField setEnabled:NO];
        [self.signOutButton setEnabled:NO];
        [self.signOutButton setTitle:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) hideKeyboard: (UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

- (void)setLoginStatus
{
    if ([MyUtils getSession] != nil && [[MyUtils getSession] length] > 0) {
        [self.signedInView setHidden:NO];
        [self.signedOutView setHidden:YES];
        [self.signOutButton setEnabled:YES];
        [self.signOutButton setTitle:@"SIGN OUT"];
    }
    else {
        [self.signedInView setHidden:YES];
        [self.signedOutView setHidden:NO];
        [self.signOutButton setEnabled:NO];
        [self.signOutButton setTitle:@""];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SignInViewController class]]) {
        SignInViewController *vc = (SignInViewController *)segue.destinationViewController;
        [vc setDelegate:self];
    }
    else if ([segue.destinationViewController isKindOfClass:[SignUpViewController class]]) {
        SignUpViewController *vc = (SignUpViewController *)segue.destinationViewController;
        [vc setDelegate:self];
    }
}

- (IBAction)logout:(id)sender {
    [MyUtils setUserID:@""];
    [MyUtils setUserName:@""];
    [MyUtils setSession:@""];
    [MyUtils setSendBirdID:@""];
    [self setLoginStatus];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Sign out"
                                message:@"You signed out."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeButton = [UIAlertAction
                                  actionWithTitle:@"Close"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                  }];
    
    [alert addAction:closeButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [self setData];
}

- (IBAction)save:(id)sender {
    NSString *nickname = [self.nicknameTextField text];
    if ([nickname length] == 0) {
        return;
    }
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    [Server updateNickname:nickname resultBlock:^(NSDictionary *response, NSError *error) {
        NSLog(@"Response: %@", response);
        if ([[response objectForKey:@"result"] isEqualToString:@"success"]) {
            [MyUtils setUserName:nickname];
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Success"
                                        message:@"Nickname has been changed."
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeButton = [UIAlertAction
                                          actionWithTitle:@"Close"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                          }];
            
            [alert addAction:closeButton];
        }
        else {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:[response objectForKey:@"message"]
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeButton = [UIAlertAction
                                          actionWithTitle:@"Close"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                          }];
            
            [alert addAction:closeButton];
        }

        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
    }];
}

- (void)setData
{
    if ([MyUtils getSession] != nil && [[MyUtils getSession] length] > 0) {
        [self.nicknameTextField setText:[MyUtils getUserName]];
        [self.nicknameTextField setEnabled:YES];
    }
    else {
        [self.nicknameTextField setText:@""];
        [self.nicknameTextField setEnabled:NO];
    }
}

#pragma mark - SignInViewControllerDelegate
- (void)openSignUpViewController
{
    
}

- (void)refreshSignInStatus
{
    [self setLoginStatus];
    [self setData];
}

#pragma mark - SignUpViewControllerDelegate
- (void)refreshSignUpStatus
{
    [self setLoginStatus];
    [self setData];
}


@end
