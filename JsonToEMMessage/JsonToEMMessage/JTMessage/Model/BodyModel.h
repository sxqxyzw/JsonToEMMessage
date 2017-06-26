//
//  BodyModel.h
//  JsonToEMMessage
//
//  Created by WYZ on 2017/5/29.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, BodyType) {
    BodyType_txt         =             1,
    BodyType_img,
    BodyType_video,
    BodyType_loc,
    BodyType_audio,
    BodyType_file,
    BodyType_cmd
};



@interface BodyModel : BaseModel

@property (assign, nonatomic) BodyType bodyType;

@end


@interface TextBodyModel : BodyModel

@property (strong, nonatomic) NSString *msg;

@end


@interface CmdBodyModel : BodyModel

@property (strong, nonatomic) NSString *action;

@end


@interface LocBodyModel : BodyModel

@property (assign, nonatomic, readonly) double longitude;

@property (assign, nonatomic, readonly) double latitude;

@property (strong, nonatomic) NSString *addr;

@end


@interface FileBodyModel : BodyModel

@property (assign, nonatomic, readonly) long long fileLength;

@property (strong, nonatomic) NSString *filename;

@property (strong, nonatomic) NSString *secret;

@property (strong, nonatomic) NSString *url;

@end


@interface ImgBodyModel : FileBodyModel

@property (assign, nonatomic, readonly) float width;

@property (assign, nonatomic, readonly) float height;

@property (strong, nonatomic) NSString *thumbnailDisplayName;

@end

@interface AudioBodyModel : FileBodyModel

@property (assign, nonatomic, readonly) int duration;

@end

@interface VideoBodyModel : FileBodyModel

@property (strong, nonatomic) NSString *thumb_secret;

@property (strong, nonatomic) NSString *thumb;

@property (assign, nonatomic, readonly) float width;

@property (assign, nonatomic, readonly) float height;

@property (assign, nonatomic, readonly) int duration;

@end





