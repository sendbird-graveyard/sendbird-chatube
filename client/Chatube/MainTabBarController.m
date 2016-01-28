//
//  MainTabBarController.m
//  Chatube
//
//  Created by Jed Kyung on 1/20/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "MainTabBarController.h"
#import "SettingsViewController.h"
#import "PopularVideoViewController.h"
#import "NewVideoViewController.h"
#import "MyUtils.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:8],
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x8791a5)
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:8],
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                                        } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:8],
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                                        } forState:UIControlStateHighlighted];
    
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"tab_hot_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"tab_new_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"tab_settings_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_hot_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_new_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_settings_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item tag] == 0) {
        PopularVideoViewController *vc = (PopularVideoViewController *)[[self viewControllers] objectAtIndex:0];
        [vc setLoginStatus];
    }
    else if ([item tag] == 1) {
        NewVideoViewController *vc = (NewVideoViewController *)[[self viewControllers] objectAtIndex:1];
        [vc setLoginStatus];
    }
    else if ([item tag] == 2) {
        SettingsViewController *vc = (SettingsViewController *)[[self viewControllers] objectAtIndex:2];
        [vc setLoginStatus];        
        [vc setData];
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

@end
