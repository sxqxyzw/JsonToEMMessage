//
//  PayloadModel.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/29.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "BaseModel.h"

@class BodyModel;

@interface PayloadModel : BaseModel

@property (strong, nonatomic) NSDictionary *ext;

@property (strong, nonatomic) BodyModel *body;

@property (strong, nonatomic) NSString *from;

@property (strong, nonatomic) NSString *to;

@end
