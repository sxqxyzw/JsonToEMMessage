//
//  RecordModel.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/25.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "BodyModel.h"

typedef NS_ENUM(NSInteger, ChatType) {
    ChatType_chat             =          0,
    ChatType_chatgroup,
    ChatType_chatroom
};


@interface RecordModel : BaseModel

@property (strong, nonatomic) NSString *msg_id;

@property (assign, nonatomic) long long timeStamp;

@property (assign, nonatomic) ChatType chatType;

@property (strong, nonatomic) NSString *to;

@property (strong, nonatomic) NSString *from;

@property (strong, nonatomic) NSDictionary *ext;

@property (strong, nonatomic) BodyModel *body;


- (instancetype)initWithJson:(NSString *)jsonStr;

@end


