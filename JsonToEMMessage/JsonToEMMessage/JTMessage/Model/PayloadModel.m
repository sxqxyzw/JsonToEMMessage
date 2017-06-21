//
//  PayloadModel.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/29.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "PayloadModel.h"
#import "BodyModel.h"

@interface PayloadModel()

@property (strong, nonatomic) NSArray *bodies;

@end

@implementation PayloadModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        NSDictionary *body = _bodies.firstObject;
        _body = [self bodyWithDict:body];
    }
    return self;
}

- (BodyModel *)bodyWithDict:(NSDictionary *)dict {
    NSString *type = dict[@"type"];
    BodyModel *model = nil;
    if ([type isEqualToString:@"txt"]) {
        model = [[TextBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_txt;
    }
    else if ([type isEqualToString:@"cmd"]) {
        model = [[CmdBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_cmd;
    }
    else if ([type isEqualToString:@"img"]) {
        model = [[ImgBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_img;
    }
    else if ([type isEqualToString:@"audio"]) {
        model = [[AudioBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_audio;
    }
    else if ([type isEqualToString:@"video"]) {
        model = [[VideoBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_video;
    }
    else if ([type isEqualToString:@"loc"]) {
        model = [[LocBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_loc;
    }
    else if ([type isEqualToString:@"file"]) {
        model = [[FileBodyModel alloc] initWithDict:dict];
        model.bodyType = BodyType_file;
    }
    
    
    return model;
}


@end
