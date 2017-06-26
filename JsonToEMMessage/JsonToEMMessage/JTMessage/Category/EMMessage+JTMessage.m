//
//  EMMessage+JTMessage.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/13.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "EMMessage+JTMessage.h"
#import "EMMessageBody+JTMessage.h"
#import "RecordModel.h"

@implementation EMMessage (JTMessage)

+ (EMMessage *_Nullable)messageWithRecord:(RecordModel * _Nonnull)model {
    EMMessage *message = nil;
    NSString *currentUsername = [EMClient sharedClient].currentUsername;
    if (currentUsername.length == 0) {
        return message;
    }
    EMMessageBody *body = [[EMMessageBody alloc] initWithRecordModel:model];
    if (!body) {
        return nil;
    }
    BOOL isSend = [currentUsername isEqualToString:model.from] ? YES : NO;
    NSString *conversationId = (isSend || model.chatType > ChatType_chat) ? model.to : model.from;
    
    message = [[EMMessage alloc] initWithConversationID:conversationId from:model.from to:model.to body:body ext:model.ext];
    
    message.messageId = model.msg_id;
    message.direction = isSend ? EMMessageDirectionSend : EMMessageDirectionReceive;
    message.chatType = (EMChatType)model.chatType;
    message.timestamp = model.timeStamp;
    message.localTime = model.timeStamp;
    message.status = EMMessageStatusSuccessed;
    message.isRead = YES;
    message.isReadAcked = YES;
    message.isDeliverAcked = YES;
    return message;
}

@end

