//
//  JTManager.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/2.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Singleton_interface + (instancetype)manager;

typedef void(^JTCompletionBlock)(EMMessage *message, EMError *error);

#import "RecordModel.h"

@interface JTManager : NSObject

Singleton_interface

@property (nonatomic, copy) JTCompletionBlock block;

//正则分隔json格式字符串聊天记录，用于整个记录文件的
- (NSArray *)regularExpression:(NSString *)jsonStr;

- (BOOL)isNeedImport:(RecordModel *)model
        conversation:(EMConversation *)conversation;

- (void)insertMessageRecords:(NSArray<RecordModel *> *)msgRecords;

@end
