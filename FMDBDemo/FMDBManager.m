//
//  FMDBManager.m
//  FMDBDemo
//
//  Created by 李强 on 14-12-23.
//  Copyright (c) 2014年 思埠集团. All rights reserved.
//

#import "FMDBManager.h"

#import "FMDatabaseQueue.h"

#import "FMDatabaseAdditions.h"

@implementation FMDBManager
{
    FMDatabaseQueue * _dbQueue;
    NSInteger _openCount;//数据库被打开的次数
}

#define STUDENT_NAME @"student"

+(id)shareDBManager
{
    static FMDBManager * manager = nil;
    if (!manager) {
        manager = [[FMDBManager alloc] init];
    }
    return manager;
}

- (id)init
{
    if (self = [super init]) {
//         [self createUserDB];
    }
    return self;
}

+ (NSString *)DBFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    
    NSString *a = [NSString stringWithFormat:@"%@.sqlite",STUDENT_NAME];
    
    NSString *path = [docsPath stringByAppendingPathComponent:a];
    
    return path;
}

- (void)createUserDB {
    NSString *dbFilePath = [FMDBManager DBFilePath];
    NSLog(@"%@",[FMDBManager DBFilePath]);
     _openCount = 0;
    _database = [FMDatabase databaseWithPath:dbFilePath];
}

#pragma mark - 计算数据库打开关闭次数

-(BOOL)open
{
    if (0 == _openCount) {
        if (![_database open]) {
            printf("不能打开数据库\n");
            return NO;
        }
    }
    _openCount++;
    return YES;
}

-(BOOL)close
{
    _openCount--;
    if (0 == _openCount) {
        if (![_database close]) {
            printf("关闭数据库失败\n");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 数据库 增，删，改，查

#define kUserTableName @"SUser"

- (void)createTableWithName:(NSString *)name{
   
    if(!_database){
        [self createUserDB];
    }
    if ([_database open]) {
        //为数据库设置缓存，提高查询效率
        [self.database setShouldCacheStatements:YES];
        if (![self.database tableExists:kUserTableName]) {
//            NSString * sql = @"create table if not exists SUser(ID integer primary key autoincrement ,stu_userID TEXT not null, stu_age TEXT in default(0), stu_name TEXT)";
            NSString * sql = @"create table SUser(ID integer primary key autoincrement ,stu_userID TEXT, stu_age TEXT, stu_name TEXT)";
            BOOL ret = [_database executeUpdate:sql];
            if (!ret) {
                NSLog(@"创建 %@ 失败",kUserTableName);
            }else{
                NSLog(@"创建 %@ 成功",kUserTableName);
            }
        }
    }
    [_database close];
}

//增
-(void)insertDataToTable:(NSString *)userID age:(NSString *)age name:(NSString *)name{
    if ([self open]) {
        [_database setShouldCacheStatements:YES];
        if (![_database tableExists:kUserTableName]) {
            NSLog(@"用户表不存在");
            [self close];
            return;
        }
         FMResultSet * set = [_database executeQuery:@"select * from SUser where stu_name = ?",name];
        /*检测是否重名*/
        if (![set next]) {
            BOOL ret = [_database executeUpdate:@"insert into SUser(stu_userID,stu_age,stu_name) values(?,?,?)",userID,age,name];
            if (ret) {
                NSLog(@"插入数据成功");
            }else{
                NSLog(@"插入数据失败");
            }
        }else{
            NSLog(@"stu_name重名");
        }
        [self close];
    }
}

//删
-(void)deleteDataFromTable:(NSString *)name{
    if ([self open]) {
        [_database setShouldCacheStatements:YES];
        if (![_database tableExists:kUserTableName]) {
            NSLog(@"消息表不存在");
            [self close];
            return;
        }else{
            FMResultSet * set = [_database executeQuery:@"select * from SUser where stu_name = ?",name];
            if ([set next]) {
                BOOL isSuccess = [_database executeUpdate:@"delete from SUser where stu_name = ?",name];
                if (!isSuccess) {
                    NSLog(@"删除失败");
                }else{
                    NSLog(@"删除成功");
                }
            }else{
                NSLog(@"数据库不存在该学生");
            }
        }
    }
        [self close];
}

//改
-(void)updateDataFromTable:(NSString *)userID age:(NSString *)age name:(NSString *)name
{
    if ([self open]) {
        [_database setShouldCacheStatements:YES];
        if (![_database tableExists:kUserTableName]) {
            NSLog(@"用户表不存在");
            [self close];
            return;
        }else{
//            FMResultSet * set = [_database executeQuery:@"select * from SUser where stu_userID = ? and stu_name = ?",userID,name];
            FMResultSet * set = [_database executeQuery:@"select * from SUser where stu_name = ?",name];
            if ([set next]) {
                NSLog(@"%@",name);
                BOOL result = [_database executeUpdate:@"update SUser set stu_age = ? where stu_name = ?",age,name];
                if (!result) {
                    NSLog(@"更新表的数据失败");
                }else{
                    NSLog(@"更新数据库成功");
                }
            }else{
                NSLog(@"数据库不存在该学生");
            }
        }
    }
    [self close];
}

//查
-(NSArray *)selectDataFromTable:(NSString *)name{
    if ([self open]) {
        [_database setShouldCacheStatements:YES];
        if (![_database tableExists:kUserTableName]) {
            NSLog(@"消息表不存在");
            [self close];
        }
        FMResultSet* set =[_database executeQuery:@"select * from SUser where stu_name = ?",name];
        while([set next]){
            NSLog(@"%@",[set stringForColumn:@"stu_userID"]);
            NSArray * array = @[[set stringForColumn:@"stu_userID"],[set stringForColumn:@"stu_age"],[set stringForColumn:@"stu_name"]];
            return array;
        }
    }
    return nil;
}


-(void)dealloc
{
    if([_database open])
        [_database close];
}

@end
