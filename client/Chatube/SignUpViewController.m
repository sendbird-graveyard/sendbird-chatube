//
//  SignUpViewController.m
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "SignUpViewController.h"
#import "Server.h"
#import "MyUtils.h"

#define TEXT_FIELD_LEFT_PADDING 12.0
#define TEXT_FIELD_RIGHT_PADDING 12.0

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];

    [self.emailTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_LEFT_PADDING, 20)]];
    [self.emailTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailTextField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_RIGHT_PADDING, 20)]];
    [self.emailTextField setRightViewMode:UITextFieldViewModeAlways];
    [self.emailTextField setDelegate:self];
    
    [self.passwordTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)]];
    [self.passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)]];
    [self.passwordTextField setRightViewMode:UITextFieldViewModeAlways];
    [self.passwordTextField setDelegate:self];
    
    [self.indicatorView setHidden:YES];
    [self.indicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
    NSString *email = [self.emailTextField text];
    NSString *password = [self.passwordTextField text];
    if ([email length] == 0 || [password length] == 0) {
        return;
    }
    NSString *nickname = [[email componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@"]] objectAtIndex:0];
    if ([nickname length] == 0) {
        return;
    }
    NSString *deviceToken = @"";
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    [Server signUpWithEmail:email nickname:nickname password:password deviceToken:deviceToken resultBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:[error domain]
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeButton = [UIAlertAction
                                          actionWithTitle:@"Close"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                          }];
            
            [alert addAction:closeButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            if ([[response objectForKey:@"result"] isEqualToString:@"error"]) {
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
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                NSDictionary *userDict = [response objectForKey:@"user"];
                NSString *email = [userDict objectForKey:@"email"];
                NSString *nickname = [userDict objectForKey:@"nickname"];
                NSString *session = [userDict objectForKey:@"session"];
                NSString *sendbird_id = [userDict objectForKey:@"sendbird_id"];
                [MyUtils setUserID:email];
                [MyUtils setUserName:nickname];
                [MyUtils setSession:session];
                [MyUtils setSendBirdID:sendbird_id];
                UIAlertController *alert = [UIAlertController
                                         alertControllerWithTitle:@"Welcome"
                                         message:@"Thank you for signing up."
                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* closeButton = [UIAlertAction
                                              actionWithTitle:@"Close"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action) {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                  [self.delegate refreshSignUpStatus];
                                              }];
                
                [alert addAction:closeButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
