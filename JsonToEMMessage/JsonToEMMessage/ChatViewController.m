//
//  ChatViewController.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/5.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "ChatViewController.h"

#import "RecordModel.h"
#import "JTManager.h"

@interface ChatViewController ()<EaseMessageViewControllerDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    UIButton *insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    insertBtn.frame = CGRectMake(0, 0, 44, 44);
    [insertBtn setTitle:@"插入" forState:UIControlStateNormal];
    [insertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(insertMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *insertBar = [[UIBarButtonItem alloc] initWithCustomView:insertBtn];
    
    [self.navigationItem setRightBarButtonItems:@[insertBar]];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertMessage {
    [self importServerMessages];
}

- (void)importServerMessages {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"record_file" ofType:@""];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *records = [[JTManager manager] regularExpression:jsonStr];
        NSMutableArray *messages = [NSMutableArray array];
        for (NSString *record in records) {
            RecordModel *model = [[RecordModel alloc] initWithJson:record];
            BOOL isNeedInsert = [[JTManager manager] isNeedImport:model conversation:weakSelf.conversation];
            if (isNeedInsert) {
                [messages addObject:model];
            }
        }
        [[JTManager manager] insertMessageRecords:messages];
    });
    
    [JTManager manager].downloadCompletionblock = ^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"下载成功，更新UI");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block NSInteger index = -1;
                [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj conformsToProtocol:@protocol(IMessageModel)]) {
                        EaseMessageModel *model = (EaseMessageModel *)obj;
                        if ([model.messageId isEqualToString:message.messageId]) {
                            index = idx;
                            *stop = YES;
                        }
                    }
                }];
                if (index >= 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                    });
                }
            });
        }
    };
    
    [JTManager manager].insertCompletionblock = ^(NSArray<EMMessage *> *failMessages) {
        [weakSelf.messsagesSource removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf tableViewDidTriggerHeaderRefresh];
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
