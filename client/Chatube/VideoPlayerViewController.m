//
//  VideoPlayerViewController.m
//  Chatube
//
//  Created by Jed Gyeong on 1/15/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MyUtils.h"

@interface VideoPlayerViewController () {
    NSMutableArray *messages;
    BOOL isLoadingMessage;
    BOOL openImagePicker;
    long long lastMessageTimestamp;
    long long firstMessageTimestamp;
    BOOL scrollLocked;
    SendBirdChannel *currentChannel;
    BOOL lightTheme;
}

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    openImagePicker = NO;
    isLoadingMessage = NO;
    lastMessageTimestamp = LLONG_MIN;
    firstMessageTimestamp = LLONG_MAX;
    scrollLocked = NO;
    lightTheme = YES;
    
    messages = [[NSMutableArray alloc] init];
    
    [self.navigationBarTitle setTitle:[self.video title]];
    [self.sendFileButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self.sendMessageButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self.messageTextField.layer setBorderColor:[[UIColor blueColor] CGColor]];
    
    [self.messageTextField setDelegate:self];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    if ([[MyUtils getUserID] length] > 0 && [[MyUtils getSession] length] > 0) {
        [self startChattingWithPreviousMessage:YES];
        isLoadingMessage = YES;
    }
    else {
        [self.sendFileButton setEnabled:NO];
        [self.sendMessageButton setEnabled:NO];
        [self.messageTextField setEnabled:NO];
    }

    // For a full list of player parameters, see the documentation for the HTML5 player
    // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1,
                                 };
    [self.playerView setDelegate:self];
    [self.playerView loadWithVideoId:self.video.videoID playerVars:playerVars];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.playerView stopVideo];
    if (!openImagePicker) {
        [SendBird disconnect];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)closeKeyboard:(id)sender {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startChattingWithPreviousMessage:(BOOL)tf
{
    [SendBird initAppId:@"<YOUR_APP_ID>"];
    [SendBird loginWithUserId:[MyUtils getUserID] andUserName:[MyUtils getUserName] andUserImageUrl:[MyUtils getUserProfileImage] andAccessToken:@""];
    [SendBird joinChannel:[self.video channelUrl]];
    [SendBird setEventHandlerConnectBlock:^(SendBirdChannel *channel) {
        currentChannel = channel;
    } errorBlock:^(NSInteger code) {
        
    } channelLeftBlock:^(SendBirdChannel *channel) {
        
    } messageReceivedBlock:^(SendBirdMessage *message) {
        if (lastMessageTimestamp < [message getMessageTimestamp]) {
            lastMessageTimestamp = [message getMessageTimestamp];
        }
        
        if (firstMessageTimestamp > [message getMessageTimestamp]) {
            firstMessageTimestamp = [message getMessageTimestamp];
        }
        
        if ([message isPast]) {
            [messages insertObject:message atIndex:0];
        }
        else {
            [messages addObject:message];
        }
        [self scrollToBottomWithReloading:YES animated:NO forced:NO];
    } systemMessageReceivedBlock:^(SendBirdSystemMessage *message) {
        
    } broadcastMessageReceivedBlock:^(SendBirdBroadcastMessage *message) {
        if (lastMessageTimestamp < [message getMessageTimestamp]) {
            lastMessageTimestamp = [message getMessageTimestamp];
        }
        
        if (firstMessageTimestamp > [message getMessageTimestamp]) {
            firstMessageTimestamp = [message getMessageTimestamp];
        }
        
        if ([message isPast]) {
            [messages insertObject:message atIndex:0];
        }
        else {
            [messages addObject:message];
        }
        [self scrollToBottomWithReloading:YES animated:NO forced:NO];
    } fileReceivedBlock:^(SendBirdFileLink *fileLink) {
        if (lastMessageTimestamp < [fileLink getMessageTimestamp]) {
            lastMessageTimestamp = [fileLink getMessageTimestamp];
        }
        
        if (firstMessageTimestamp > [fileLink getMessageTimestamp]) {
            firstMessageTimestamp = [fileLink getMessageTimestamp];
        }
        
        if ([fileLink isPast]) {
            [messages insertObject:fileLink atIndex:0];
        }
        else {
            [messages addObject:fileLink];
        }
        [self scrollToBottomWithReloading:YES animated:NO forced:NO];
    } messagingStartedBlock:^(SendBirdMessagingChannel *channel) {

    } messagingUpdatedBlock:^(SendBirdMessagingChannel *channel) {
        
    } messagingEndedBlock:^(SendBirdMessagingChannel *channel) {
        
    } allMessagingEndedBlock:^{
        
    } messagingHiddenBlock:^(SendBirdMessagingChannel *channel) {
        
    } allMessagingHiddenBlock:^{
        
    } readReceivedBlock:^(SendBirdReadStatus *status) {
        
    } typeStartReceivedBlock:^(SendBirdTypeStatus *status) {
        
    } typeEndReceivedBlock:^(SendBirdTypeStatus *status) {
        
    } allDataReceivedBlock:^(NSUInteger sendBirdDataType, int count) {
        
    } messageDeliveryBlock:^(BOOL send, NSString *message, NSString *data, NSString *messageId) {
        
    }];
    
    if (tf) {
        NSLog(@"Channel: %@", [self.video channelUrl]);
        [[SendBird queryMessageListInChannel:[self.video channelUrl]] prevWithMessageTs:LLONG_MAX andLimit:50 resultBlock:^(NSMutableArray *queryResult) {
            for (SendBirdMessage *message in queryResult) {
                if ([message isPast]) {
                    [messages insertObject:message atIndex:0];
                }
                else {
                    [messages addObject:message];
                }
                
                if (lastMessageTimestamp < [message getMessageTimestamp]) {
                    lastMessageTimestamp = [message getMessageTimestamp];
                }
                
                if (firstMessageTimestamp > [message getMessageTimestamp]) {
                    firstMessageTimestamp = [message getMessageTimestamp];
                }
                
            }
            [self scrollToBottomWithReloading:YES animated:NO forced:NO];
            scrollLocked = NO;
            [SendBird connectWithMessageTs:LLONG_MAX];
        } endBlock:^(NSError *error) {
            
        }];
    }
    else {
        [SendBird connect];
    }
}

- (void)keyboardWillShow:(NSNotification*)notif
{
    NSDictionary *keyboardInfo = [notif userInfo];
    NSValue *keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    [self.inputViewBottomMargin setConstant:keyboardFrameEndRect.size.height];
    [self.tableTopMargin setConstant:0];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.view updateConstraints];
    lightTheme = NO;
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottomWithReloading:YES animated:NO forced:YES];
    });
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self.inputViewBottomMargin setConstant:0];
    [self.tableTopMargin setConstant:200];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.view updateConstraints];
    lightTheme = YES;
    [self scrollToBottomWithReloading:YES animated:NO forced:NO];
}

- (void)scrollToBottomWithReloading:(BOOL)reload animated:(BOOL)animated forced:(BOOL)forced
{
    if (reload) {
        [self.tableView reloadData];
    }
    
    if (scrollLocked && forced == NO) {
        return;
    }
    
    unsigned long msgCount = [messages count];
    if (msgCount > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(msgCount - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void) loadPreviousMessages {
    if (isLoadingMessage) {
        return;
    }
    isLoadingMessage = YES;

    [[SendBird queryMessageListInChannel:[self.video channelUrl]] prevWithMessageTs:firstMessageTimestamp andLimit:50 resultBlock:^(NSMutableArray *queryResult) {
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];
        for (SendBirdMessage *message in queryResult) {
            if ([message isPast]) {
                [newMessages insertObject:message atIndex:0];
            }
            else {
                [newMessages addObject:message];
            }
            
            if (lastMessageTimestamp < [message getMessageTimestamp]) {
                lastMessageTimestamp = [message getMessageTimestamp];
            }
            
            if (firstMessageTimestamp > [message getMessageTimestamp]) {
                firstMessageTimestamp = [message getMessageTimestamp];
            }
        }
        NSUInteger newMsgCount = [newMessages count];
        
        if (newMsgCount > 0) {
            [messages insertObjects:newMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newMsgCount)]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if ([newMessages count] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([newMessages count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                isLoadingMessage = NO;
            });
        }
        else {
            isLoadingMessage = NO;
        }
    } endBlock:^(NSError *error) {
        isLoadingMessage = NO;
    }];
}

- (IBAction)clickSendFileButton:(id)sender {
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    mediaUI.mediaTypes = mediaTypes;
    [mediaUI setDelegate:self];
    openImagePicker = YES;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (void) sendMessage
{
    NSString *message = [self.messageTextField text];
    if ([message length] > 0) {
        [self.messageTextField setText:@""];
        [SendBird sendMessage:message];
    }
    scrollLocked = NO;
}

- (IBAction)clickSendMessageButton:(id)sender {
    [self sendMessage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    [self.view endEditing:YES];
    
    return YES;
}

-(void) setVideoData:(Video *)video
{
    self.video = video;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        UITableViewCell *commonCell = nil;
        SendBirdMessageModel *msgModel = (SendBirdMessageModel *)[messages objectAtIndex:[indexPath row]];
        
        if ([msgModel isKindOfClass:[SendBirdMessage class]]) {
            OpenChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatMessageCell"];
            
            [cell setTheme:lightTheme];
            [cell setMessage:(SendBirdMessage *)msgModel];
            
            commonCell = cell;
        }
        else if ([msgModel isKindOfClass:[SendBirdBroadcastMessage class]]) {
            OpenChatBroadcastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatBroadcastCell"];
            [cell setBroadcastMessage:(SendBirdBroadcastMessage *)msgModel];
            commonCell = cell;
        }
        else if ([msgModel isKindOfClass:[SendBirdFileLink class]]) {
            OpenChatFileMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatFileCell"];
            [cell setTheme:lightTheme];
            [cell setFileMessage:(SendBirdFileLink *)msgModel];
            commonCell = cell;
        }
        
        if ([indexPath row] == 0) {
            [self loadPreviousMessages];
        }
        
        if ([indexPath row] == [messages count] - 1) {
            scrollLocked = NO;
        }

        [commonCell setNeedsLayout];
        
        return commonCell;
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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [messages count] - 1) {
        scrollLocked = YES;
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollLocked  = YES;
//    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        CGFloat height = 0;
        SendBirdMessageModel *msgModel = (SendBirdMessageModel *)[messages objectAtIndex:[indexPath row]];
        
        if ([msgModel isKindOfClass:[SendBirdMessage class]]) {
            OpenChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatMessageCell"];
            
            [cell setMessage:(SendBirdMessage *)msgModel];
            height = [cell getCellHeight];
        }
        else if ([msgModel isKindOfClass:[SendBirdBroadcastMessage class]]) {
            OpenChatBroadcastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatBroadcastCell"];
            [cell setBroadcastMessage:(SendBirdBroadcastMessage *)msgModel];
            height = [cell getCellHeight];
        }
        else if ([msgModel isKindOfClass:[SendBirdFileLink class]]) {
            OpenChatFileMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenChatFileCell"];
            [cell setFileMessage:(SendBirdFileLink *)msgModel];
            height = [cell getCellHeight];
        }
        
        return height;
    }
    else {
        return 64;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *messageSubMenu;
    UIAlertAction *messageAction;
    UIAlertAction *messageCancelAction;
    
    if ([[messages objectAtIndex:indexPath.row] isKindOfClass:[SendBirdMessage class]]) {
//        SendBirdMessage *message = (SendBirdMessage *)[messages objectAtIndex:indexPath.row];
//        
//        if ([[[message sender] guestId] isEqualToString:[SendBird getUserId]]) {
//            return;
//        }
//        
//        NSString *actionTitle = [NSString stringWithFormat:@"Start messaging with %@", [message getSenderName]];
//        messageSubMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        messageAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [SendBird startMessagingWithUserId:[[message sender] guestId]];
//        }];
//        messageCancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
//        [messageSubMenu addAction:messageAction];
//        [messageSubMenu addAction:messageCancelAction];
//        
//        [self presentViewController:messageSubMenu animated:YES completion:nil];
        [self.view endEditing:YES];
    }
    else {
        return;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    __block UIImage *originalImage, *editedImage, *imageToUse;
    __block NSURL *imagePath;
    __block NSString *imageName;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
            editedImage = (UIImage *) [info objectForKey:
                                       UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey:
                                         UIImagePickerControllerOriginalImage];
            
            if (originalImage) {
                imageToUse = originalImage;
            } else {
                imageToUse = editedImage;
            }
            
            NSData *imageFileData = UIImagePNGRepresentation(imageToUse);
            imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            imageName = [imagePath lastPathComponent];
            
            [SendBird uploadFile:imageFileData type:@"image/jpg" hasSizeOfFile:[imageFileData length] withCustomField:@"" uploadBlock:^(SendBirdFileInfo *fileInfo, NSError *error) {
                openImagePicker = NO;
                [SendBird sendFile:fileInfo];
            }];
        }
        else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeVideo, 0) == kCFCompareEqualTo) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            
            NSData *videoFileData = [NSData dataWithContentsOfURL:videoURL];
            
            [SendBird uploadFile:videoFileData type:@"video/mov" hasSizeOfFile:[videoFileData length] withCustomField:@"" uploadBlock:^(SendBirdFileInfo *fileInfo, NSError *error) {
                openImagePicker = NO;
                [SendBird sendFile:fileInfo];
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        openImagePicker = NO;
    }];
}

#pragma mark - YTPlayerViewDelegate
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [playerView playVideo];
}

@end
