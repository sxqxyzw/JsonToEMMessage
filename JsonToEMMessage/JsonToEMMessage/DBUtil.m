//
//  DBUtil.m
//  JsonToEMMessage
//
//  Created by WYZ on 2017/6/6.
//  Copyright © 2017年 WYZ. All rights reserved.
//

#import "DBUtil.h"
#import "FMDB.h"

@implementation DBUtil

+(NSMutableArray *)selectImageMessages{
    NSMutableArray *selectChangeArray=[[NSMutableArray alloc]init];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/HyphenateSDK/easemobDB/%@.db", [EMClient sharedClient].currentUsername];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM message"];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]){
        
        NSLog(@"--- %@",[rs stringForColumn:@"msgbody"]);
        NSString *jsonStr = [rs stringForColumn:@"msgbody"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSObject *obj = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *msgbody = (NSDictionary *)obj;
            if (msgbody[@"bodies"]) {
                NSArray *bodies = msgbody[@"bodies"];
                NSDictionary *body = bodies.firstObject;
                if (body[@"type"] && [body[@"type"] isEqualToString:@"img"]) {
                    [selectChangeArray addObject:body];
                }
            }
        }
    }
    [db close];
    return selectChangeArray;
}


@end
