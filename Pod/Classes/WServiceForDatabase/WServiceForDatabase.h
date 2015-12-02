//
//  WServiceForDatabase.h
//
//
//  Created by lin jiawei on 13-9-3.
//  Copyright (c) 2013年 lin jiawei. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "WOrmProtocol.h"

typedef NS_ENUM(NSInteger, TypeObjectForArrAndDic)
{
    TypeObject_Dictionary = 0,
    TypeObject_Array = 1
};
/*
 * 数据库便捷操作类
 */
@interface WServiceForDatabase : NSObject

//注:设置数据库文件
@property(copy,nonatomic)NSString * dbFileWithPath;

//单例
+ (WServiceForDatabase *)sharedInstance;
#pragma mark - 数据库操作

#pragma mark -表操作

// 多张表一起创建，数组中必须是实现了WOrmProtocol代理的class
- (BOOL)wCreateDbTablesWithWModes:(NSArray *)array;

//创建wModel对应的数据库表
-(BOOL)wCreateDbTableWithWmodel:(id<WOrmProtocol>)wModel;

//创建wModel对应的数据库表
-(BOOL)wCreateDbTableWithClassWmodel:(Class<WOrmProtocol>)classWModel;

//删除表中全部数据(不删除表)
-(BOOL)wDeleteTableDatas:(Class<WOrmProtocol>)classWModel;

//删除表
-(BOOL)wDeleteTable:(id<WOrmProtocol>)wModel;

//判断wModel对应的数据库表是否存在
-(BOOL)wIsExistDbTableWithWmodel:(id<WOrmProtocol>)wModel;

//判断wModel对应的数据库表是否存在
-(BOOL)wIsExistDbTableWithClassWmodel:(Class<WOrmProtocol>)classWModel;

#pragma mark -单条数据操作

//根据一个带主键的wModel去查wModel
-(id<WOrmProtocol>)wSelectWmodel:(id<WOrmProtocol>)wModel;

//填充wModel
-(BOOL)wSelectToSetWmodel:(id<WOrmProtocol>)wModel;

//插入wModel到wModel对应的数据库表
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel;
//插入wModel到wModel对应的数据库表(isAutoAddPrimaryKey:主键是否自动增加)
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsAutoAddPrimaryKey:(BOOL)IsAutoAddPrimaryKey;

//插入wModel到wModel对应的数据库表
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack;
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack IsAutoAddPrimaryKey:(BOOL)isAutoAddPrimaryKey;

//删除记录
-(BOOL)wDeleteWmodel:(id<WOrmProtocol>)wModel;

-(BOOL)wUpdateWmodel:(id<WOrmProtocol>)wModel;

//更新wModel到wModel对应的数据库表
-(BOOL)wUpdateWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack;

-(BOOL)wInputWmodel:(id<WOrmProtocol>)wModel;

-(BOOL)wUpdateOrInsertWmodel:(id<WOrmProtocol>)wModel;

-(BOOL)wReplaceWmodel:(id<WOrmProtocol>)wModel;

//根据主键查一条记录
-(NSDictionary *)wSelectDicFromWmode:(id<WOrmProtocol>)wModel;

#pragma mark -多条数据操作

-(BOOL)wInsertWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack;

-(BOOL)wUpdateWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack;

-(BOOL)wReplaceWmodels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack;

-(BOOL)wInputWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack;

#pragma mark -根据数据库语句操作

-(void)wSelectArrDicWithSqlCommand:(NSString *)sqlCommand GotResult:(void(^)(NSArray * arrDicResults))callback;

-(void)wSelectArrModelsWithSqlCommand:(NSString *)sqlCommand
                           ModelClass:(Class<WOrmProtocol>)classForWmodel
                            GotResult:(void(^)(NSArray * wModelsFromDB))callback;

-(NSArray *)wSelectArrDicWithSqlCommand:(NSString *)sql;

-(NSArray *)wSelectArrModelsWithSqlCommand:(NSString *)sql ModelClass:(Class<WOrmProtocol>)classForWmodel;

-(FMResultSet *)wSelectFMResultSetWithSqlCommand:(NSString *)sql;

-(void)wUpdateWithSqlCommand:(NSString *)sqlCommand GotResult:(void(^)(BOOL isOK))callback;

-(BOOL)wUpdateWithSqlCommand:(NSString *)sqlCommand;

//FMResultSet转为NSArray
-(NSArray *)wFMResultSet2Arr:(FMResultSet *)rs;

#pragma mark - SQL语句帮助

//拼接建表语句
-(NSString *)wGetSqlCreateTableWithWmodel:(id<WOrmProtocol>)wModel;
//拼接删表语句
-(NSString *)wGetSqlDeleteTableWithWmodel:(id<WOrmProtocol>)wModel;

//拼接SQL插入语句
-(NSString *)wGetSqlInsertWithWmodel:(id<WOrmProtocol>)wModel;
//拼接SQL插入语句(isAutoAddPrimaryKey:主键是否自动增加)
-(NSString *)wGetSqlInsertWithWmodel:(id<WOrmProtocol>)wModel IsAutoAddPrimaryKey:(BOOL)isAutoAddPrimaryKey;
//拼接SQL插入语句
-(NSString *)wGetSqlInsertWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName;
-(NSString *)wGetSqlInsertWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys IsAutoAddPrimaryKey:(BOOL)IsAutoAddPrimaryKey;

//拼接SQL删除语句(根据主键删除)
-(NSString *)wGetSqlDeleteWithWmodel:(id<WOrmProtocol>)wModel;

//拼接SQL替换语句(根据主键替换)
-(NSString *)wGetSqlReplaceWithWmodel:(id<WOrmProtocol>)wModel;
//拼接SQL替换语句(根据主键替换)
-(NSString *)wGetSqlReplaceWithWmodelDic:(NSDictionary *)wModelDic
                               TableName:(NSString *)tableName
                             PrimaryKeys:(NSArray *)primaryKeys;

//拼接SQL更新语句(根据主键更新)
-(NSString *)wGetSqlUpdateWithWmodel:(id<WOrmProtocol>)wModel;
//拼接SQL更新语句(根据主键更新)
-(NSString *)wGetSqlUpdateWithWmodelDic:(NSDictionary *)wModelDic
                              TableName:(NSString *)tableName
                            PrimaryKeys:(NSArray *)primaryKeys;

//拼接SQL查询语句(根据主键查)
-(NSString *)wGetSqlSelectWithWmodel:(id<WOrmProtocol>)wModel;
-(NSString *)wGetSqlSelectWithWmodelDic:(NSDictionary *)wModelDic
                              TableName:(NSString *)tableName
                            PrimaryKeys:(NSArray *)primaryKeys;





@end





