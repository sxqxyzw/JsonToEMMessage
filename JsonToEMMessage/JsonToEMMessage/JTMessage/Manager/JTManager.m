//
//  JTManager.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/2.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "JTManager.h"
#import "EMMessage+JTMessage.h"

#define Singleton_implementation \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)manager \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}


@interface JTManager()

@property (nonatomic, copy) dispatch_queue_t insertQueue;

@property (nonatomic, copy) dispatch_queue_t downloadQueue;

@end

@implementation JTManager

Singleton_implementation

- (instancetype)init {
    self = [super init];
    if (self) {
        _insertQueue = dispatch_queue_create("insertMessage", DISPATCH_QUEUE_SERIAL);
        _downloadQueue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Private


#pragma mark - Public

//正则分隔json格式字符串聊天记录
- (NSArray *)regularExpression:(NSString *)jsonStr {
    
    NSString *regular = @"(\\{\"msg_id\")([\\s\\S]*?)(\"\\}\\})";
    if (jsonStr.length == 0) {
        return nil;
    }
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regular
                                                                         options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *match = [exp matchesInString:jsonStr options:NSMatchingReportProgress range:NSMakeRange(0, jsonStr.length)];
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in match) {
        NSString *str = [jsonStr substringWithRange:result.range];
        [results addObject:str];
    }
    return results;
}

- (BOOL)isNeedImport:(RecordModel *)model
        conversation:(EMConversation *)conversation
{
    if (conversation.type > EMConversationTypeChat)
    {
        if ([model.to isEqualToString:conversation.conversationId]) {
            return YES;
        }
    }
    else {
        NSString *currentUser = [EMClient sharedClient].currentUsername;
        if (currentUser.length == 0) {
            return NO;
        }
        if (([currentUser isEqualToString:model.from] && [model.to isEqualToString:conversation.conversationId]) ||
            ([currentUser isEqualToString:model.to] && [model.from isEqualToString:conversation.conversationId]))
        {
            return YES;
        }
    }
    
    return NO;
}


- (void)insertMessageRecords:(NSArray<RecordModel *> *)msgRecords {
    if (msgRecords.count <= 0) {
        return ;
    }
    __block EMConversation *conversation = nil;
    __weak JTManager *weakManager = _instance;
    dispatch_async(_insertQueue, ^{
        __strong JTManager *strongManager = weakManager;
        if (strongManager) {
            [msgRecords enumerateObjectsUsingBlock:^(RecordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EMMessage *message = [EMMessage messageWithRecord:obj];
                if (!conversation) {
                    conversation = [[EMClient sharedClient].chatManager getConversation:message.conversationId
                                                                                   type:(EMConversationType)message.chatType
                                                                       createIfNotExist:YES];
                }
                [conversation insertMessage:message error:nil];
                NSLog(@"--- %d", message.body.type);
                switch (message.body.type) {
                    case EMMessageBodyTypeVideo:
                    {
                        dispatch_async(strongManager.downloadQueue, ^{
                            [[EMClient sharedClient].chatManager downloadMessageThumbnail:message progress:nil completion:^(EMMessage *message, EMError *error) {
                                if (!error) {
                                    NSLog(@"");
                                }
                            }];
                        });
                    }
                        break;
                    case EMMessageBodyTypeVoice:
                    case EMMessageBodyTypeImage:
                    {
                        dispatch_async(strongManager.downloadQueue, ^{
                            [[EMClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(EMMessage *message, EMError *error) {
                                if (!error) {
                                    NSLog(@"");
                                }
                            }];
                        });
                    }
                        break;
                    default:
                        break;
                }
            }];
            strongManager.block(nil, nil);
        }
    });
}


@end
