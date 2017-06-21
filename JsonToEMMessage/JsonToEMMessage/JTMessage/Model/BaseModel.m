//
//  BaseModel.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/29.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (dict.allKeys.count <= 0) {
        return nil;
    }
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
