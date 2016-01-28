//
//  SecondViewController.m
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "NewVideoViewController.h"
#import "MyUtils.h"

@interface NewVideoViewController ()

@end

@implementation NewVideoViewController {
    long long offset;
    NSMutableArray<Video *> *videoArray;
    BOOL hasNext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    hasNext = YES;
    videoArray = [[NSMutableArray alloc] init];
    
    [self.loginOutButton setTitleTextAttributes:@{
                                                  NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                  NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                                                  } forState:UIControlStateNormal];
    
    [self setLoginStatus];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = UIColorFromRGB(0xeef1f6);
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 48, 0)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView addSubview:self.refreshControl];
    
    [self loadNextVideoList];
}

- (void)setLoginStatus
{
    if ([MyUtils getSession] != nil && [[MyUtils getSession] length] > 0) {
        [self.loginOutButton setTitle:@""];
        [self.loginOutButton setEnabled:NO];
    }
    else {
        [self.loginOutButton setTitle:@"SIGN IN"];
        [self.loginOutButton setEnabled:YES];
    }
}

- (IBAction)clickLoginOut:(id)sender {
    if ([MyUtils getSession] != nil && [[MyUtils getSession] length] > 0) {
        [MyUtils setUserID:@""];
        [MyUtils setUserName:@""];
        [MyUtils setSession:@""];
        [MyUtils setSendBirdID:@""];
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
        
        [self presentViewController:alert animated:YES completion:^{
            [self.loginOutButton setTitle:@"Sign In"];
        }];
    }
    else {
        SignInViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SignInViewController"];
        [vc setDelegate:self];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    offset = 0;
    hasNext = YES;
    [Server queryVideoListOffset:offset limit:20 orderBy:2 resultBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            
        }
        else {
            if ([[response objectForKey:@"result"] isEqualToString:@"error"]) {
                
            }
            else {
                NSMutableArray<Video *> *tmpVideoArray = [[NSMutableArray alloc] init];
                for (NSDictionary *item in [response objectForKey:@"video_list"]) {
                    Video *video = [[Video alloc] initWithDic:item];
                    [tmpVideoArray addObject:video];
                    offset++;
                }
                
                if ([tmpVideoArray count] == 0) {
                    hasNext = NO;
                }
                else {
                    [videoArray removeAllObjects];
                    [videoArray addObjectsFromArray:tmpVideoArray];
                }
                [self.tableView reloadData];
            }
        }
        [self.refreshControl endRefreshing];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewVideo:(id)sender {
    NSString *session = [MyUtils getSession];
    if (session == nil || [session length] == 0) {
        // Open Sign In View Controller.
        SignInViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SignInViewController"];
        [vc setDelegate:self];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        // Open Register Video View Controller.
        RegisterVideoViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterVideoViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)loadNextVideoList {
    if (hasNext == NO) {
        return;
    }
    if (offset == 0) {
        [videoArray removeAllObjects];
    }
    [Server queryVideoListOffset:offset limit:20 orderBy:2 resultBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            
        }
        else {
            if ([[response objectForKey:@"result"] isEqualToString:@"error"]) {
                
            }
            else {
                NSMutableArray<Video *> *tmpVideoArray = [[NSMutableArray alloc] init];
                for (NSDictionary *item in [response objectForKey:@"video_list"]) {
                    Video *video = [[Video alloc] initWithDic:item];
                    [tmpVideoArray addObject:video];
                    offset++;
                }
                
                if ([tmpVideoArray count] == 0) {
                    hasNext = NO;
                }
                else {
                    [videoArray addObjectsFromArray:tmpVideoArray];
                }
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - SignInViewControllerDelegate
- (void)openSignUpViewController
{
    SignUpViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListTableViewCell"];
        Video *video = (Video *)[videoArray objectAtIndex:[indexPath row]];
        [cell setVideo:video];
        
        if ([indexPath row] + 1 == [videoArray count]) {
            [self loadNextVideoList];
        }
        
        return cell;
    }
    else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = indexPath;
    VideoPlayerViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];

    Video *video = [videoArray objectAtIndex:[path row]];
    [Server viewVideo:[video videoID]];
    [vc setVideoData:video];

    [self.tableView deselectRowAtIndexPath:path animated:NO];
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - RegisterVideoViewControllerDelegate
- (void)refreshPopularVideoView {
    [self setLoginStatus];
    offset = 0;
    hasNext = YES;
    [self loadNextVideoList];
}

#pragma mark - SignInViewControllerDelegate
- (void)refreshSignInStatus
{
    [self setLoginStatus];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[VideoPlayerViewController class]]) {
        //        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        //        VideoPlayerViewController *vc = (VideoPlayerViewController *)segue.destinationViewController;
        //        Video *video = [videoArray objectAtIndex:[path row]];
        //        [vc setVideo:video];
        //
        //        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
}

@end
