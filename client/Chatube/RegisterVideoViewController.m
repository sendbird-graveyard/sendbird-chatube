//
//  RegisterVideoViewController.m
//  Chatube
//
//  Created by Jed Kyung on 1/17/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "RegisterVideoViewController.h"
#import "Server.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "UIImageView+AFNetworking.h"
#import "MyUtils.h"

#define TEXT_FIELD_LEFT_PADDING 12
#define TEXT_FIELD_RIGHT_PADDING 12

@interface RegisterVideoViewController ()

@end

@implementation RegisterVideoViewController {
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    page = 0;
    
    self.thumbnailUrl = @"";

    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.nextButton setTitleColor:UIColorFromRGB(0xf38f8b) forState:UIControlStateDisabled];
    [self.nextButton setBackgroundImage:[MyUtils imageFromColor:UIColorFromRGB(0xe62117)] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[MyUtils imageFromColor:UIColorFromRGB(0xc41910)] forState:UIControlStateSelected];
    [self.nextButton setBackgroundImage:[MyUtils imageFromColor:UIColorFromRGB(0xc41910)] forState:UIControlStateHighlighted];
    [self.nextButton.layer setCornerRadius:3.0];
    [self.nextButton.layer setMasksToBounds:YES];
    [self.nextButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [self.nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setEnabled:NO];
    [self.rightBarButton setCustomView:self.nextButton];
    
    [self.videoUrlTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_LEFT_PADDING, 20)]];
    [self.videoUrlTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.videoUrlTextField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_RIGHT_PADDING, 20)]];
    [self.videoUrlTextField setRightViewMode:UITextFieldViewModeAlways];
    
    [self.titleTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_LEFT_PADDING, 20)]];
    [self.titleTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.titleTextField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXT_FIELD_RIGHT_PADDING, 20)]];
    [self.titleTextField setRightViewMode:UITextFieldViewModeAlways];
    
    [self.indicatorView setHidden:YES];
    [self.indicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButton:(UIButton *)btn
{
    if (page == 0) {
        if ([[self.videoUrlTextField text] length] == 0) {
            return;
        }
        
        [self.pageTwoView setHidden:NO];
        [self.pageOneView setHidden:YES];
        page = 1;
        [self.nextButton setTitle:@"DONE" forState:UIControlStateNormal];
        [self getInfo];
    }
    else {
        [self confirmVideo];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back:(id)sender {
    if (page == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.pageTwoView setHidden:YES];
        [self.pageOneView setHidden:NO];
        page = 0;
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    }

}

- (void)getInfo
{
    [self.view endEditing:YES];
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    [Server getYouTubeInfoUrl:[self.videoUrlTextField text] resultBlock:^(NSDictionary *response, NSError *error) {
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
            if ([[response objectForKey:@"result"] isEqualToString:@"success"]) {
                self.videoId = [response objectForKey:@"videoId"];
                self.name = [response objectForKey:@"name"];
                self.thumbnailUrl = [response objectForKey:@"thumbnailUrl"];
                [self.titleTextField setText:self.name];
                [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:self.thumbnailUrl]];
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
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
    }];
}

- (void)confirmVideo
{
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    
    self.name = [self.titleTextField text];
    self.url = [self.videoUrlTextField text];
    [Server registerVideoWithURL:self.url videoId:self.videoId title:self.name thumbnail:self.thumbnailUrl resultBlock:^(NSDictionary *response, NSError *error) {
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
        
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
            if ([[response objectForKey:@"result"] isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Success"
                                            message:@"Your video is registered."
                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* closeButton = [UIAlertAction
                                              actionWithTitle:@"Close"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action) {
                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                      [self.delegate refreshPopularVideoView];
                                                  }];
                                              }];
                
                [alert addAction:closeButton];
                
                [self presentViewController:alert animated:YES completion:nil];
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
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}

@end
