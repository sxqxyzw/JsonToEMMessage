//
//  ListViewController.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/5.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "ListViewController.h"
#import "ChatViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversationType type = EMConversationTypeChat;
    NSString *chatter = @"sx410";
    if (indexPath.row == 1) {
        type = EMConversationTypeGroupChat;
        chatter = @"1483679778394";
    }
    else if (indexPath.row == 2) {
        type = EMConversationTypeChatRoom;
        chatter = @"16534960406530";
    }
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:chatter conversationType:type];
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

@end
