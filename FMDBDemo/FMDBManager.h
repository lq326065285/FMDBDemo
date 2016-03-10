//
//  FMDBManager.h
//  FMDBDemo
//
//  Created by 李强 on 14-12-23.
//  Copyright (c) 2014年 思埠集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface FMDBManager : NSObject
{
//    FMDatabase * _database;
}
@property (nonatomic,retain) FMDatabase *database;
+(id)shareDBManager;//单例
-(void)createTableWithName:(NSString *)name;//创建表
-(void)insertDataToTable:(NSString *)userID age:(NSString *)age name:(NSString *)name;//插入数据
-(void)updateDataFromTable:(NSString *)userID age:(NSString *)age name:(NSString *)name;//查询数据库
-(void)deleteDataFromTable:(NSString *)name;//删除数据
-(NSArray *)selectDataFromTable:(NSString *)name;//查询数据
@end
