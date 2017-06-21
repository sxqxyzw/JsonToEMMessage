//
//  RecordModel.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/25.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "RecordModel.h"
#import "PayloadModel.h"

@interface RecordModel()

@property (strong, nonatomic) NSString *direction;

@property (strong, nonatomic) NSDictionary *payload;

@property (strong, nonatomic) PayloadModel *payloadModel;

@property (strong, nonatomic) NSString *chat_type;

@property (strong, nonatomic) NSString *timestamp;

@end

@implementation RecordModel

- (instancetype)initWithJson:(NSString *)jsonStr {
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *record = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return [self initWithDict:record];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (dict.allKeys.count <= 0) {
        return nil;
    }
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _payloadModel = [[PayloadModel alloc] initWithDict:_payload];
    }
    return self;
}

- (ChatType)chatType {
    if ([_chat_type isEqualToString:@"groupchat"]) {
        return ChatType_chatgroup;
    }
    else if ([_chat_type isEqualToString:@""]) {
        return ChatType_chatroom;
    }
    return ChatType_chat;
}

- (NSString *)to {
    return _payloadModel.to;
}

- (NSString *)from {
    return _payloadModel.from;
}

- (NSDictionary *)ext {
    return _payloadModel.ext;
}

- (BodyModel *)body {
    return _payloadModel.body;
}

- (long long)timeStamp {
    return [_timestamp longLongValue];
}

@end


