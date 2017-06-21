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
#import "DBUtil.h"

#define WEAKSELF __weak typeof(self) weakSelf = self;

@interface ChatViewController ()<EaseMessageViewControllerDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    
//    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"DB.png"] highlightedImage:[UIImage imageNamed:@"DB.png"] title:@""];
    
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
    
    [JTManager manager].block = ^(EMMessage *message, EMError *error) {
        [weakSelf.messsagesSource removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf tableViewDidTriggerHeaderRefresh];
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - EaseMessageViewControllerDelegate
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index
{
    NSArray *array = [DBUtil selectImageMessages];
    NSLog(@"发送的图片url：%@",array);
    if (array.count > 0) {
        NSDictionary *body = array.firstObject;
        NSLog(@"url --- %@",body[@"url"]);
    }
    
}

@end
