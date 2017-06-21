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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversationType type = EMConversationTypeChat;
    NSString *chatter = @"sx410";
    if (indexPath.row == 1) {
        type = EMConversationTypeGroupChat;
        chatter = @"1496100649501";
    }
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:chatter conversationType:type];
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}

@end
