//
//  EMMessageBody+JTMessage.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/14.
//  Copyright © 2017年 WYZ. All rights reserved.
//

//#ifdef ISLITE_SDK
//#import <HyphenateLite/HyphenateLite.h>
//#else
#import <Hyphenate/Hyphenate.h>
//#endif

@class RecordModel;

@interface EMMessageBody (JTMessage)

//初始化消息体
- (instancetype)initWithRecordModel:(RecordModel *)model;

@end
