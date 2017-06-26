//
//  EMMessageBody+JTMessage.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/14.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "EMMessageBody+JTMessage.h"
#import "RecordModel.h"


@implementation EMTextMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeText) {
        return nil;
    }
    NSString *text = [(TextBodyModel *)model.body msg];
    self = [[EMTextMessageBody alloc] initWithText:text];
    return self;
}

@end

@implementation EMCmdMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeCmd) {
        return nil;
    }
    NSString *action = [(CmdBodyModel *)model.body action];
    self = [[EMCmdMessageBody alloc] initWithAction:action];
    return self;
}

@end

@implementation EMLocationMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeLocation) {
        return nil;
    }
    LocBodyModel *_bodyModel = (LocBodyModel *)model.body;
    self = [[EMLocationMessageBody alloc] initWithLatitude:_bodyModel.latitude longitude:_bodyModel.longitude address:_bodyModel.addr];
    return self;
}

@end

@interface EMFileMessageBody (JTMessage)

- (void)setFileRemote:(RecordModel *)model;

@end

@implementation EMFileMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    EMMessageBodyType _bodyType = (EMMessageBodyType)model.body.bodyType;
    if (_bodyType != EMMessageBodyTypeFile) {
        return nil;
    }
    FileBodyModel *_bodyModel = (FileBodyModel *)model.body;
    self = [[EMFileMessageBody alloc] initWithLocalPath:@"" displayName:_bodyModel.filename];
    [self setFileRemote:model];
    return self;
}

- (void)setFileRemote:(RecordModel *)model {
    if (!self) {
        return;
    }
    FileBodyModel *_bodyModel = (FileBodyModel *)model.body;
    self.remotePath = _bodyModel.url;
    self.secretKey = _bodyModel.secret;
    self.fileLength = _bodyModel.fileLength;
    NSString *currentUsername = [EMClient sharedClient].currentUsername;
    NSString *user = [currentUsername isEqualToString:model.from] ? model.to : model.from;
    NSString *filename = (NSString *)[[self.remotePath componentsSeparatedByString:@"/"] lastObject];
    NSString *directory = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/HyphenateSDK/appdata/%@/%@", currentUsername, user];
    NSString *path = [directory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL isExist = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (isExist && !error) {
            self.localPath = path;
        }
    }
}

@end


@implementation EMImageMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeImage) {
        return nil;
    }
    ImgBodyModel *_bodyModel = (ImgBodyModel *)model.body;
    self = [[EMImageMessageBody alloc] initWithLocalPath:@"" displayName:_bodyModel.filename];
    [self setFileRemote:model];
    self.size = CGSizeMake(_bodyModel.width, _bodyModel.height);
    self.thumbnailRemotePath = _bodyModel.url;
    self.thumbnailSecretKey = _bodyModel.secret;
    self.thumbnailFileLength = _bodyModel.fileLength;
    self.thumbnailDisplayName = [NSString stringWithFormat:@"thumb_%@",_bodyModel.filename];
    self.thumbnailSize = self.size;
    return self;
}

@end


@implementation EMVideoMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeVideo) {
        return nil;
    }
    VideoBodyModel *_bodyModel = (VideoBodyModel *)model.body;
    self = [[EMVideoMessageBody alloc] initWithLocalPath:@"" displayName:_bodyModel.filename];
    [self setFileRemote:model];
    self.thumbnailSecretKey = _bodyModel.thumb_secret;
    self.thumbnailRemotePath = _bodyModel.thumb;
    self.thumbnailSize = CGSizeMake(_bodyModel.width, _bodyModel.height);
    self.duration = _bodyModel.duration;
    return self;
}

@end


@implementation EMVoiceMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    if ((EMMessageBodyType)model.body.bodyType != EMMessageBodyTypeVoice) {
        return nil;
    }
    AudioBodyModel *_bodyModel = (AudioBodyModel *)model.body;
    self = [[EMVoiceMessageBody alloc] initWithLocalPath:@"" displayName:_bodyModel.filename];
    [self setFileRemote:model];
    self.duration = _bodyModel.duration;
    return self;
}

@end


@implementation EMMessageBody (JTMessage)

- (instancetype)initWithRecordModel:(RecordModel *)model {
    switch (model.body.bodyType) {
        case BodyType_cmd:
            self = [[EMCmdMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_file:
            self = [[EMFileMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_video:
            self = [[EMVideoMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_audio:
            self = [[EMVoiceMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_loc:
            self = [[EMLocationMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_img:
            self = [[EMImageMessageBody alloc] initWithRecordModel:model];
            break;
        case BodyType_txt:
            self = [[EMTextMessageBody alloc] initWithRecordModel:model];
            break;
        default:
            self = nil;
            break;
    }
    return self;
}

@end
