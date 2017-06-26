//
//  EMMessage+JTMessage.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/13.
//  Copyright © 2017年 WYZ. All rights reserved.
//

//#ifdef ISLITE_SDK
//#import <HyphenateLite/HyphenateLite.h>
//#else
#import <Hyphenate/Hyphenate.h>
//#endif

@class RecordModel;

@interface EMMessage (JTMessage)

+ (EMMessage *_Nullable)messageWithRecord:(RecordModel * _Nonnull)model;

@end
