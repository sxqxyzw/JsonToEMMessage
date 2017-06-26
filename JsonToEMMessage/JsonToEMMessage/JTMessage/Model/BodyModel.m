//
//  BodyModel.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/29.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "BodyModel.h"

@interface BodyModel()

@property (strong, nonatomic) NSString *type;

@end

@implementation BodyModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        
    }
    return self;
}


@end


@implementation TextBodyModel


@end

@implementation CmdBodyModel

@end


@interface LocBodyModel()

@property (strong, nonatomic) NSNumber *lng;

@property (strong, nonatomic) NSNumber *lat;

@end

@implementation LocBodyModel

- (double)latitude {
    return [_lat doubleValue];
}

- (double)longitude {
    return [_lng doubleValue];
}


@end


@interface FileBodyModel()

@property (strong, nonatomic) NSString *file_length;

@end

@implementation FileBodyModel

- (long long)fileLength {
    return [_file_length longLongValue];
}

@end



@interface ImgBodyModel()

@property (strong, nonatomic) NSDictionary *size;

@property (strong, nonatomic) NSString *thumbFilename;

@end

@implementation ImgBodyModel

- (float)width {
    return [_size[@"width"] floatValue];
}

- (float)height {
    return [_size[@"height"] floatValue];
}

- (NSString *)thumbnailDisplayName {
    if (_thumbFilename.length <= 0) {
        return [NSString stringWithFormat:@"thumb_%@", self.filename];
    }
    return _thumbFilename;
}

@end


@interface AudioBodyModel()

@property (strong, nonatomic) NSString *length;

@end

@implementation AudioBodyModel

- (int)duration {
    return [_length intValue];
}

@end


@interface VideoBodyModel()

@property (strong, nonatomic) NSDictionary *size;

@property (strong, nonatomic) NSNumber *length;

@end

@implementation VideoBodyModel

- (float)width {
    return [_size[@"width"] floatValue];
}

- (float)height {
    return [_size[@"height"] floatValue];
}

- (int)duration {
    return [_length intValue];
}

@end


