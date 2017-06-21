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
