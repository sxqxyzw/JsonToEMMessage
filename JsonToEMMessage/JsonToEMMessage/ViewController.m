//
//  ViewController.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/25.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _account.text = @"sx201";
    _password.text = @"1";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hidekeyBoard:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)doLogin:(id)sender {
    [self.view endEditing:YES];
    if (_account.text.length <= 0 || _password.text.length <= 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient] loginWithUsername:_account.text password:_password.text completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            [[EMClient sharedClient].chatManager getAllConversations];
            [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 error:nil];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"nav"];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
        }
    }];
}


@end


/*
 NSString *str = @"{\"msg_id\":\"319663521891616756\",\"timestamp\":\"1491992263569\",\"direction\":\"outgoing\",\"to\":\"user2\",\"from\":\"user1\",\"chat_type\":\"chat\",\"payload\":{\"ext\":{},\"bodies\":[{\"msg\":\"haha\",\"type\":\"txt\"}],\"from\":\"user1\",\"to\":\"user2\"}}";
 
 NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
 NSDictionary *msgInfo = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
 NSDictionary *payload = msgInfo[@"payload"];
 NSArray *bodies = payload[@"bodies"];
 NSDictionary *bodyInfo = bodies.firstObject;
 
 
 NSString *type = bodyInfo[@"type"];
 
 EMMessage *message;
 
 if ([type isEqualToString:@"txt"]) {
 EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:bodyInfo[@"msg"]];
 NSString *from = payload[@"from"];
 NSString *to = payload[@"to"];
 NSDictionary *ext = payload[@"ext"];
 message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:ext];
 message.timestamp = [msgInfo[@"timestamp"] longLongValue];
 message.localTime = message.timestamp;
 message.messageId = msgInfo[@"msg_id"];
 message.status = EMMessageStatusSuccessed;
 message.isRead = YES;
 message.isReadAcked = YES;
 message.isDeliverAcked = YES;
 
 NSString *chat_type = msgInfo[@"chat_type"];
 if ([chat_type isEqualToString:@"chat"]) {
 message.chatType = EMChatTypeChat;
 }
 
 if ([from isEqualToString:[EMClient sharedClient].currentUsername]) {
 message.conversationId = to;
 message.direction = EMMessageDirectionSend;
 }
 else {
 message.conversationId = from;
 message.direction = EMMessageDirectionReceive;
 }
 }
 
 [[EMClient sharedClient].chatManager importMessages:@[message] completion:^(EMError *aError) {
 if (!aError) {
 //成功
 }
 }];
 */
