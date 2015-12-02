//
//  WServiceForDatabase.m
//
//
//  Created by lin jiawei on 13-9-3.
//  Copyright (c) 2013年 lin jiawei. All rights reserved.
//

#import "WServiceForDatabase.h"
//#import "WBaseModel.h"
@interface WServiceForDatabase()

@property(retain,nonatomic)FMDatabaseQueue * dbQueue;

@end

@implementation WServiceForDatabase
//单例
//SINGLETON_FOR_CLASS_Implementation(WServiceForDatabase)

#pragma mark - 单例

static WServiceForDatabase * _sharedWServiceForDatabase = nil;

#if !__has_feature(objc_arc)//如果是MRC
+ (WServiceForDatabase *)sharedInstance { //单例
    @synchronized(self){
        if (_sharedWServiceForDatabase == nil){
            _sharedWServiceForDatabase = [[self alloc] init];
        }
    }
    return _sharedWServiceForDatabase;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedWServiceForDatabase == nil)
        {
            _sharedWServiceForDatabase = [super allocWithZone:zone];
            return _sharedWServiceForDatabase;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release{
}

- (id)autorelease{
    return self;
}

#else//如果是ARC
+ (WServiceForDatabase *)sharedInstance { //单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWServiceForDatabase = [[self alloc] init];
    });
    return _sharedWServiceForDatabase;
}
+ (WServiceForDatabase *)sharedWServiceForDatabase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWServiceForDatabase = [[self alloc] init];
    });
    return _sharedWServiceForDatabase;
}
#endif

#pragma mark - 生命周期
- (void)dealloc
{
#if !__has_feature(objc_arc)//如果是MRC
    [_dbFileWithPath release];
    //    [_dbQueue release];
    [super dealloc];
#endif
}

- (id)init
{
    if (self= [super init]) {
    }
    return self;
}

-(void)setDbFileWithPath:(NSString *)dbFileWithPath
{
    //NSLog(@"DbFile Path = %@",dbFileWithPath);
#if !__has_feature(objc_arc)//如果是MRC
    if (_dbFileWithPath != dbFileWithPath) {
        [_dbFileWithPath release];
        _dbFileWithPath = [dbFileWithPath copy];
        //创建数据库队列实例dbQueue,如果路径中不存在数据库文件,sqlite会自动创建
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFileWithPath];
    }
#else
    if (_dbFileWithPath != dbFileWithPath) {
        _dbFileWithPath = dbFileWithPath;
        //创建数据库队列实例dbQueue,如果路径中不存在数据库文件,sqlite会自动创建
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFileWithPath];
    }
#endif
}


#pragma mark - 数据库操作

#pragma mark -表操作

// 多张表一起创建，数组中必须是实现了WOrmProtocol代理的class
- (BOOL)wCreateDbTablesWithWModes:(NSArray *)array
{
    BOOL flog = YES;
    for (Class class in array) {
        //        id<WOrmProtocol> wModel = [[class alloc]init];
        flog &= [self wCreateDbTableWithClassWmodel:class];
        //#if !__has_feature(objc_arc)//如果是MRC
        //        [wModel release];
        //#endif
    }
    return flog;
}

//创建wModel对应的数据库表
-(BOOL)wCreateDbTableWithWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isOK = NO;
    //    if (![self wIsExistDbTableWithWmodel:wModel]) {
    NSString * sqlForCreateTable = [self wGetSqlCreateTableWithWmodel:wModel];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isOK = [db executeUpdate:sqlForCreateTable];
    }];
    //    }
    return isOK;
}

//创建wModel对应的数据库表
-(BOOL)wCreateDbTableWithClassWmodel:(Class<WOrmProtocol>)classWModel
{
    __block Boolean isOK = NO;
    if (!classWModel) {
        return NO;
    }
    if (![self wIsExistDbTableWithClassWmodel:classWModel]){
        NSString * sqlForCreateTable = [classWModel wSqlForCreateTable];
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            isOK = [db executeUpdate:sqlForCreateTable];
        }];
    }
    return isOK;
}

//删除表中全部数据(不删除表)
-(BOOL)wDeleteTableDatas:(Class<WOrmProtocol>)classWModel
{
    __block Boolean isOK = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         isOK = [db executeUpdate:[NSString stringWithFormat:@"delete from %@",[classWModel wTableName]]];
     }];
    return isOK;
}

//删除表
-(BOOL)wDeleteTable:(id<WOrmProtocol>)wModel
{
    __block Boolean isOK = NO;
    if ([self wIsExistDbTableWithWmodel:wModel]) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             isOK = [db executeUpdate:[self wGetSqlDeleteTableWithWmodel:wModel]];
         }];
    }
    return isOK;
}

//判断wModel对应的数据库表是否存在
-(BOOL)wIsExistDbTableWithWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isExist = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) AS 'COUNT' FROM sqlite_master WHERE type ='table' AND name = ?", [[wModel class] wTableName]];
        while ([rs next])
        {
            if ([rs intForColumn:@"COUNT"]) {
                isExist = YES;
            }
        }
    }];
    return isExist;
}

//判断wModel对应的数据库表是否存在
-(BOOL)wIsExistDbTableWithClassWmodel:(Class<WOrmProtocol>)classWModel
{
    __block Boolean isExist = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) AS 'COUNT' FROM sqlite_master WHERE type ='table' AND name = ?", [classWModel wTableName]];
        while ([rs next])
        {
            if ([rs intForColumn:@"COUNT"]) {
                isExist = YES;
            }
        }
    }];
    return isExist;
}



#pragma mark -单条数据操作

-(id<WOrmProtocol>)wSelectWmodel:(id<WOrmProtocol>)wModel
{
    
    __block id<WOrmProtocol> obj = nil;
    NSDictionary * dicRs = [self wSelectDicFromWmode:wModel];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         if (dicRs){
             obj = [[[wModel class] alloc] init];
             
             if ([obj conformsToProtocol:@protocol(WOrmProtocol)] && [obj respondsToSelector:@selector(wSetModelWithDic:Type:)])
             {
                 [obj wSetModelWithDic:dicRs Type:NO];
             }
#if !__has_feature(objc_arc)//如果是MRC
             [obj autorelease];
#endif
         }
     }];
    
    return obj;
}

//填充wModel
-(BOOL)wSelectToSetWmodel:(id<WOrmProtocol>)wModel
{
    __block BOOL isOK = NO;
    NSDictionary * dicRs = [self wSelectDicFromWmode:wModel];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         if (dicRs){
             
             if ([wModel conformsToProtocol:@protocol(WOrmProtocol)] && [wModel respondsToSelector:@selector(wSetModelWithDic:Type:)])
             {
                 isOK = YES;
                 [wModel wSetModelWithDic:dicRs Type:NO];
             }
         }
     }];
    return isOK;
}

//插入wModel到wModel对应的数据库表
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel
{
    return [self wInsertWmodel:wModel IsAutoAddPrimaryKey:NO];
}

//插入wModel到wModel对应的数据库表(isAutoAddPrimaryKey:主键是否自动增加)
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsAutoAddPrimaryKey:(BOOL)IsAutoAddPrimaryKey {
    return [self wInsertWmodel:wModel IsInTransaction:NO IsRollBack:NO IsAutoAddPrimaryKey:IsAutoAddPrimaryKey];
}

-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack IsAutoAddPrimaryKey:(BOOL)isAutoAddPrimaryKey {
    __block Boolean isOK = NO;
    
    if (!wModel) {return NO;}
    //    NSDictionary * wModelDic = [wModel wDicFromModelWithType:NO];
    //    NSString * sql = [self wSqlInsertWithWmodel:wModel WModelDic:wModelDic];
    NSString * sql = [self wGetSqlInsertWithWmodel:wModel IsAutoAddPrimaryKey:isAutoAddPrimaryKey];

    if (isInTransaction) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isExecuteOK = NO;
            if (sql) {
                //                isExecuteOK = [db executeUpdate:sql withParameterDictionary:wModelDic];
                isExecuteOK = [db executeUpdate:sql];
                isOK = [self showErrorMessage:isExecuteOK db:db];
            }
            if (isRollBack && !isExecuteOK) {
                *rollback = YES;
            }
        }];
    }else{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if (sql) {
                isOK = [self showErrorMessage:[db executeUpdate:sql] db:db];
            }
        }];
    }
    return isOK;
}

//插入wModel到wModel对应的数据库表
-(BOOL)wInsertWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack
{
    return [self wInsertWmodel:wModel IsInTransaction:isInTransaction IsRollBack:isRollBack IsAutoAddPrimaryKey:NO];
}

-(NSString *)wSqlInsertWithWmodel:(id<WOrmProtocol>)wModel WModelDic:(NSDictionary *)wModelDic{
    NSString * tableName = [[wModel class] wTableName];
    if (!wModel || !wModelDic.count || !tableName) return nil;
    NSMutableString * sqlInsert = [NSMutableString string];
    NSArray * arrPrimaryNames = [wModelDic allKeys];//得到当前传入的所有属性
    NSMutableString * strSqlKeys = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    NSMutableString * strValues = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    BOOL isAddComma = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        //一定要是[NSNumber class]或者[NSString class]
        if (!([wModelDic[strPrimaryName] isKindOfClass:[NSNumber class]] || [wModelDic[strPrimaryName] isKindOfClass:[NSString class]])) {
            continue;
        }
        
        if (isAddComma)
        {
            [strSqlKeys appendString:@","];
            [strValues appendString:@","];
        }
        
        [strSqlKeys appendFormat:@"%@",strPrimaryName];
        [strValues appendFormat:@":%@",strPrimaryName];
        isAddComma = YES;
    }
    [sqlInsert appendFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,strSqlKeys,strValues];
    return sqlInsert;
}


//删除记录
-(BOOL)wDeleteWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isOK = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         isOK = [self showErrorMessage:[db executeUpdate:[self wGetSqlDeleteWithWmodel:wModel]] db:db];
     }];
    return isOK;
}


-(BOOL)wUpdateWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isOK = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString * sql = [self wGetSqlUpdateWithWmodel:wModel];
         if (sql) {
             isOK = [self showErrorMessage:[db executeUpdate:sql] db:db];
         }
     }];
    return isOK;
}

//更新wModel到wModel对应的数据库表
-(BOOL)wUpdateWmodel:(id<WOrmProtocol>)wModel IsInTransaction:(BOOL)isInTransaction IsRollBack:(BOOL)isRollBack
{
    if (!wModel) {return NO;}
    
    __block BOOL isOK = YES;
    NSString * sql = [self wGetSqlUpdateWithWmodel:wModel];
    if (isInTransaction) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
            BOOL isExecuteOK = NO;
            if (sql) {
                
                isExecuteOK = [db executeUpdate:sql];
                isOK = [self showErrorMessage:isExecuteOK db:db];
            }
            if (isRollBack && !isExecuteOK) {
                *rollback = YES;
            }
        }];
    }else{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            BOOL isExecuteOK = NO;
            if (sql) {
                
                isExecuteOK = [db executeUpdate:sql];
                
                isOK = [self showErrorMessage:isExecuteOK db:db];
            }
        }];
    }
    return isOK;
}

-(BOOL)wInputWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isOk = YES;
    NSDictionary * dic = [self wSelectDicFromWmode:wModel];
    if (!dic) {
        isOk &= [self wInsertWmodel:wModel];
    }else
    {
        isOk &= [self wUpdateWmodel:wModel];
    }
    return isOk;
}

-(BOOL)wUpdateOrInsertWmodel:(id<WOrmProtocol>)wModel
{
    Boolean isOk = YES;
    NSDictionary * dic = [self wSelectDicFromWmode:wModel];
    if (!dic) {
        isOk &= [self wInsertWmodel:wModel];
    }else
    {
        isOk &= [self wUpdateWmodel:wModel];
    }
    return isOk;
}

-(BOOL)wReplaceWmodel:(id<WOrmProtocol>)wModel
{
    __block Boolean isOK = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         isOK = [self showErrorMessage:[db executeUpdate:[self wGetSqlReplaceWithWmodel:wModel]] db:db];
     }];
    return isOK;
}

//根据主键查一条记录
-(NSDictionary *)wSelectDicFromWmode:(id<WOrmProtocol>)wModel
{
    __block NSDictionary * dic = nil;
    NSString * sqlSelect = [self wGetSqlSelectWithWmodel:wModel];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * rs = [db executeQuery:sqlSelect];
        if([rs next]) {
            dic = rs.resultDictionary;
        }
    }];
    return dic;
}

#pragma mark -多条数据操作
-(BOOL)wInsertWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack
{
    if (!wModels.count || !classForWmodel)
    {
        return NO;
    }
    __block BOOL isOK = YES;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject * obj in wModels) {
            if ([obj isKindOfClass:classForWmodel]) {
                NSString * sql = [self wGetSqlInsertWithWmodel:(id<WOrmProtocol>)obj];
                isOK &= [db executeUpdate:sql];
            }
        }
        if (isRollBack && !isOK) {
            *rollback = !isOK;
        }
    }];
    return isOK;
}

-(BOOL)wUpdateWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack
{
    if (!wModels.count || !classForWmodel)
    {
        return NO;
    }
    __block BOOL isOK = YES;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject * obj in wModels) {
            if ([obj isKindOfClass:classForWmodel]) {
                NSString * sql = [self wGetSqlUpdateWithWmodel:(id<WOrmProtocol>)obj];
                isOK &= [db executeUpdate:sql];
            }
        }
        if (isRollBack && !isOK) {
            *rollback = !isOK;
        }
    }];
    return isOK;
}

-(BOOL)wReplaceWmodels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack
{
    if (!wModels.count || !classForWmodel)
    {
        return NO;
    }
    __block BOOL isOK = YES;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject * obj in wModels) {
            if ([obj isKindOfClass:classForWmodel]) {
                NSString * sql = [self wGetSqlReplaceWithWmodel:(id<WOrmProtocol>)obj];
                isOK &= [db executeUpdate:sql];
            }
        }
        if (isRollBack && !isOK) {
            *rollback = !isOK;
        }
    }];
    return isOK;
}

-(BOOL)wInputWModels:(NSArray *)wModels ModelClass:(Class<WOrmProtocol>)classForWmodel IsRollBack:(BOOL)isRollBack
{
    if (!wModels.count || !classForWmodel)
    {
        return NO;
    }
    __block BOOL isOK = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject * obj in wModels) {
            if ([obj isKindOfClass:classForWmodel]) {
                BOOL isInsert = YES;
                NSString * sql = [self wGetSqlInsertWithWmodel:(id<WOrmProtocol>)obj];
                isInsert &= [db executeUpdate:sql];
                if (!isInsert) {
                    sql = [self wGetSqlUpdateWithWmodel:(id<WOrmProtocol>)obj];
                    isOK &= [db executeUpdate:sql];
                }else
                {
                    isOK = YES;
                }
            }
        }
        if (isRollBack && !isOK) {
            *rollback = !isOK;
        }
    }];
    
    return isOK;
}

#pragma mark -根据数据库语句操作

-(void)wSelectArrDicWithSqlCommand:(NSString *)sqlCommand
                         GotResult:(void(^)(NSArray * arrDicResults))callback
{
    __block NSMutableArray * results = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet * rs = [db executeQuery:sqlCommand];
        if (rs) {
            results = [NSMutableArray arrayWithCapacity:rs.columnCount];
            while ([rs next]) {
                NSDictionary * dicRs = [rs resultDictionary];
                [results addObject:dicRs];
            }
        }
        callback(results);
    }];
}

-(void)wSelectArrModelsWithSqlCommand:(NSString *)sqlCommand
                           ModelClass:(Class<WOrmProtocol>)classForWmodel
                            GotResult:(void(^)(NSArray * wModelsFromDB))callback
{
    __block NSMutableArray * results = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * rs = [db executeQuery:sqlCommand];
        if (rs) {
            results = [NSMutableArray arrayWithCapacity:rs.columnCount];
            
            while ([rs next]) {
                NSDictionary * dicRs = [rs resultDictionary];
                id obj = [[classForWmodel alloc]init];
                if ([obj conformsToProtocol:@protocol(WOrmProtocol)] && [obj respondsToSelector:@selector(wSetModelWithDic:Type:)]) {
                    [obj wSetModelWithDic:dicRs Type:NO];
                }
                [results addObject:obj];
#if !__has_feature(objc_arc)//如果是MRC
                [obj release];
#endif
            }
        }
        callback(results);
    }];
    
}

-(NSArray *)wSelectArrDicWithSqlCommand:(NSString *)sql
{
    NSArray * arr = nil;
    arr = [self wFMResultSet2Arr:[self wSelectFMResultSetWithSqlCommand:sql]];
    return arr;
}

-(NSArray *)wSelectArrModelsWithSqlCommand:(NSString *)sql
                                ModelClass:(Class<WOrmProtocol>)classForWmodel
{
    if (!sql.length)
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@",[classForWmodel wTableName]];
    }
    __block NSMutableArray * results = [[NSMutableArray alloc]init];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {// [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if (rs) {
            while ([rs next]) {
                NSDictionary * dicRs = [rs resultDictionary];
                id<WOrmProtocol> obj = [[classForWmodel alloc]init];
                if ([obj conformsToProtocol:@protocol(WOrmProtocol)] && [obj respondsToSelector:@selector(wSetModelWithDic:Type:)]) {
                    [obj wSetModelWithDic:dicRs Type:NO];
                }
                else{
                    NSLog(@"error DB :wModel类%@没有实现WOrmProtocol协议",classForWmodel);
                }
                [results addObject:obj];
#if !__has_feature(objc_arc)//如果是MRC
                [obj release];
#endif
            }
        }
    }];
    return results;
}

-(FMResultSet *)wSelectFMResultSetWithSqlCommand:(NSString *)sql
{
    __block FMResultSet * rs = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        rs = [db executeQuery:sql];
    }];
    return rs;
}

-(void)wUpdateWithSqlCommand:(NSString *)sqlCommand
                   GotResult:(void(^)(BOOL isOK))callback
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        Boolean isOK = NO;
        isOK = [db executeUpdate:sqlCommand];
        callback(isOK);
    }];
}

-(BOOL)wUpdateWithSqlCommand:(NSString *)sqlCommand
{
    __block Boolean isOK = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        isOK = [self showErrorMessage:[db executeUpdate:sqlCommand] db:db];
//        isOK = [db executeUpdate:sqlCommand];
    }];
    
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
//        isOK = [db executeUpdate:sqlCommand];
//    }];
    return isOK;
}


//FMResultSet转为NSArray
-(NSArray *)wFMResultSet2Arr:(FMResultSet *)rs
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]){
        NSDictionary * dicFromRs = [rs resultDictionary];
        [array addObject:dicFromRs];
    }
    return array;
}

#pragma mark - 数据库语句拼接


//拼接SQL建表语句
-(NSString *)wGetSqlCreateTableWithWmodel:(id<WOrmProtocol>)wModel
{
    //判断是否已经有SQL语句
    NSString * sql = [[wModel class] wSqlForCreateTable];
    if (sql && ![sql isEqualToString:@""]) {
        return sql;
    }
    NSLog(@"wModel:%@,未写入建表语句!",wModel);
    return nil;
}

-(NSString *)wGetSqlDeleteTableWithWmodel:(id<WOrmProtocol>)wModel
{
    //DROP TABLE 表名称
    return [NSString stringWithFormat:@"DROP TABLE %@",[[wModel class] wTableName]];
}

//拼接SQL插入语句
-(NSString *)wGetSqlInsertWithWmodel:(id<WOrmProtocol>)wModel
{
    return [self wGetSqlInsertWithWmodel:wModel IsAutoAddPrimaryKey:NO];
}

-(NSString *)wGetSqlInsertWithWmodel:(id<WOrmProtocol>)wModel IsAutoAddPrimaryKey:(BOOL)IsAutoAddPrimaryKey {
    NSString * sqlInsert = [self wGetSqlInsertWithWmodelDic:[wModel wDicFromModelWithType:NO]
                                                  TableName:[[wModel class] wTableName]
                                                PrimaryKeys:[[wModel class] wPrimaryKeys]
                                        IsAutoAddPrimaryKey:IsAutoAddPrimaryKey];
    return sqlInsert;
}

-(NSString *)wGetSqlInsertWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys IsAutoAddPrimaryKey:(BOOL)isAutoAddPrimaryKey {
    
    if (!wModelDic.count || !tableName) {
        return nil;
    }
    NSMutableString * sqlInsert = [NSMutableString stringWithCapacity:3];
    NSArray * arrPrimaryNames = [wModelDic allKeys];
    NSMutableString * strSqlKeys = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    NSMutableString * strValues = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    BOOL isAddComma = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        NSObject * value = wModelDic[strPrimaryName];
        
        if ([value isKindOfClass:[NSDate class]]) {
            
        }
        
        //一定要是[NSNumber class]或者[NSString class]
        if (!([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSDate class]])) {
            continue;
        }
        
        //判断要不要加主键信息(用于自动增长主键的插入)
        if (isAutoAddPrimaryKey) {
            if ([self isPrimaryKeyWithString:strPrimaryName PrimaryKey:primaryKeys]) {
                continue;
            }
        }
        
        if (isAddComma)
        {
            [strSqlKeys appendString:@","];
            [strValues appendString:@","];
        }
        
        [strSqlKeys appendFormat:@"%@",strPrimaryName];
        if ([value isKindOfClass:[NSString class]]) {
            [strValues appendFormat:@"\'%@\'",value];
        }else
        {
            [strValues appendFormat:@"%@",value];
        }
        
        isAddComma = YES;
    }
    [sqlInsert appendFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,strSqlKeys,strValues];
    return sqlInsert;
}

-(NSString *)wGetSqlInsertWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName
{
    return [self wGetSqlInsertWithWmodelDic:wModelDic TableName:tableName PrimaryKeys:nil IsAutoAddPrimaryKey:NO];
    /*
    if (!wModelDic.count || !tableName) {
        return nil;
    }
    NSMutableString * sqlInsert = [NSMutableString stringWithCapacity:3];
    NSArray * arrPrimaryNames = [wModelDic allKeys];
    NSMutableString * strSqlKeys = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    NSMutableString * strValues = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    BOOL isAddComma = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        NSObject * value = wModelDic[strPrimaryName];
        
        if ([value isKindOfClass:[NSDate class]]) {
            
        }
        
        //一定要是[NSNumber class]或者[NSString class]
        if (!([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSDate class]])) {
            continue;
        }
        
        
        if (isAddComma)
        {
            [strSqlKeys appendString:@","];
            [strValues appendString:@","];
        }
        
        [strSqlKeys appendFormat:@"%@",strPrimaryName];
        if ([value isKindOfClass:[NSString class]]) {
            [strValues appendFormat:@"\'%@\'",value];
        }else
        {
            [strValues appendFormat:@"%@",value];
        }
        
        isAddComma = YES;
    }
    [sqlInsert appendFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,strSqlKeys,strValues];
    return sqlInsert;
    */
}

//拼接SQL删除语句(根据主键删除)
-(NSString *)wGetSqlDeleteWithWmodel:(id<WOrmProtocol>)wModel
{
    NSDictionary * dicOrModel = [wModel wDicFromModelWithType:NO];
    NSMutableDictionary * dicForAddPri = [[NSMutableDictionary alloc]initWithDictionary:dicOrModel];
    for (NSString * key in [[wModel class] wPrimaryKeys])
    {
        if (key.length)
        {
            dicForAddPri[key] = [wModel valueForKey:key];
        }
    }
    NSString * sqlDelete = [self wGetSqlDeleteWithWmodelDic:dicForAddPri
                                                  TableName:[[wModel class] wTableName]
                                                PrimaryKeys:[[wModel class] wPrimaryKeys]];
    return sqlDelete;
    
}
//拼接SQL删除语句(根据主键删除)
-(NSString *)wGetSqlDeleteWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys
{
    //DELETE FROM 表名称 WHERE 列名称 = 值
    NSMutableString * sqlDelete = [NSMutableString stringWithCapacity:0];
    NSArray * arrPrimaryNames = [wModelDic allKeys];
    NSMutableString * strPrimaryKeyEquslValue = [NSMutableString stringWithCapacity:primaryKeys.count];
    BOOL isAddAnd = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        //一定要是[NSNumber class]或者[NSString class]
        if (!([wModelDic[strPrimaryName] isKindOfClass:[NSNumber class]] || [wModelDic[strPrimaryName] isKindOfClass:[NSString class]])) {
            continue;
        }
        if([self isPrimaryKeyWithString:strPrimaryName PrimaryKey:primaryKeys]){
            if (isAddAnd) {
                [strPrimaryKeyEquslValue appendString:@"AND "];
            }
            if ([[wModelDic objectForKey:strPrimaryName] isKindOfClass:[NSString class]])
            {
                [strPrimaryKeyEquslValue appendFormat:@"%@ = \'%@\' ",strPrimaryName,[wModelDic objectForKey:strPrimaryName]];
            }else
            {
                [strPrimaryKeyEquslValue appendFormat:@"%@ = %@ ",strPrimaryName,[wModelDic objectForKey:strPrimaryName]];
            }
            
            isAddAnd = YES;
        }
    }
    [sqlDelete appendFormat:@"DELETE FROM %@ WHERE %@",tableName,strPrimaryKeyEquslValue];
    return sqlDelete;
}

//拼接SQL更新语句(根据主键更新)
-(NSString *)wGetSqlUpdateWithWmodel:(id<WOrmProtocol>)wModel
{
    NSMutableDictionary * dicForAddPri = [[NSMutableDictionary alloc]initWithDictionary:[wModel wDicFromModelWithType:NO]];
    for (NSString * key in [[wModel class] wPrimaryKeys])
    {
        if (key.length)
        {
            dicForAddPri[key] = [wModel valueForKey:key];
        }
    }
    NSString * sqlUpdate = [self wGetSqlUpdateWithWmodelDic:dicForAddPri
                                                  TableName:[[wModel class] wTableName]
                                                PrimaryKeys:[[wModel class] wPrimaryKeys]];
    return sqlUpdate;
}

//拼接SQL更新语句(根据主键更新)
-(NSString *)wGetSqlUpdateWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys
{
    //UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值
    NSMutableString * sqlUpdate = [NSMutableString stringWithCapacity:3];
    NSDictionary * dicModel = wModelDic;
    NSArray * arrPrimaryNames = [dicModel allKeys];
    //    NSArray * arrPrimaryKeyNames = primaryKeys;
    NSMutableString * strPrimaryEquslValue = [NSMutableString stringWithCapacity:(arrPrimaryNames.count - primaryKeys.count)];
    NSMutableString * strPrimaryKeyEquslValue = [NSMutableString stringWithCapacity:primaryKeys.count];
    BOOL isAddComma = NO;
    BOOL isAddAnd = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        //一定要是[NSNumber class]或者[NSString class]
        if (!([wModelDic[strPrimaryName] isKindOfClass:[NSNumber class]] || [wModelDic[strPrimaryName] isKindOfClass:[NSString class]])) {
            continue;
        }
        
        if (![self isPrimaryKeyWithString:strPrimaryName PrimaryKey:primaryKeys])
        {
            if (isAddComma)
            {
                [strPrimaryEquslValue appendString:@","];
            }
            if ([[dicModel objectForKey:strPrimaryName] isKindOfClass:[NSString class]]) {
                [strPrimaryEquslValue appendFormat:@"%@ = \'%@\' ",strPrimaryName,[dicModel objectForKey:strPrimaryName]];
            }else
            {
                [strPrimaryEquslValue appendFormat:@"%@ = %@ ",strPrimaryName,[dicModel objectForKey:strPrimaryName]];
            }
            isAddComma = YES;
        }else
        {
            if (isAddAnd) {
                [strPrimaryKeyEquslValue appendString:@"AND "];
            }
            if ([[dicModel objectForKey:strPrimaryName] isKindOfClass:[NSString class]]) {
                [strPrimaryKeyEquslValue appendFormat:@"%@ = \'%@\' ",strPrimaryName,[dicModel objectForKey:strPrimaryName]];
            }else
            {
                [strPrimaryKeyEquslValue appendFormat:@"%@ = %@ ",strPrimaryName,[dicModel objectForKey:strPrimaryName]];
            }
            isAddAnd = YES;
        }
    }
    [sqlUpdate appendFormat:@"UPDATE %@ SET %@WHERE %@",tableName,strPrimaryEquslValue,strPrimaryKeyEquslValue];
    return sqlUpdate;
}

//拼接SQL替换语句(根据主键替换)
-(NSString *)wGetSqlReplaceWithWmodel:(id<WOrmProtocol>)wModel
{
    NSString * sqlReplace = [self wGetSqlReplaceWithWmodelDic:[wModel wDicFromModelWithType:NO]
                                                    TableName:[[wModel class] wTableName]
                                                  PrimaryKeys:[[wModel class] wPrimaryKeys]];
    return sqlReplace;
}

//拼接SQL替换语句(根据主键替换)
-(NSString *)wGetSqlReplaceWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys
{
    NSMutableString * sqlInsert = [NSMutableString stringWithCapacity:3];
    NSArray * arrPrimaryNames = [wModelDic allKeys];
    NSMutableString * strSqlKeys = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    NSMutableString * strValues = [NSMutableString stringWithCapacity:arrPrimaryNames.count];
    BOOL isAddComma = NO;
    for (NSString * strPrimaryName in arrPrimaryNames)
    {
        //一定要是[NSNumber class]或者[NSString class]
        if (!([wModelDic[strPrimaryName] isKindOfClass:[NSNumber class]] || [wModelDic[strPrimaryName] isKindOfClass:[NSString class]])) {
            continue;
        }
        if (isAddComma)
        {
            [strSqlKeys appendString:@","];
            [strValues appendString:@","];
        }
        [strSqlKeys appendFormat:@"%@",strPrimaryName];
        if ([[wModelDic objectForKey:strPrimaryName] isKindOfClass:[NSString class]]) {
            [strValues appendFormat:@"\'%@\'",[wModelDic objectForKey:strPrimaryName]];
        }else
        {
            [strValues appendFormat:@"%@",[wModelDic objectForKey:strPrimaryName]];
        }
        
        isAddComma = YES;
    }
    [sqlInsert appendFormat:@"REPLACE INTO %@(%@) VALUES(%@)",tableName,strSqlKeys,strValues];
    return sqlInsert;
}

-(NSString *)wGetSqlSelectWithWmodel:(id<WOrmProtocol>)wModel
{
    NSDictionary * dicOrModel = [wModel wDicFromModelWithType:NO];
    NSMutableDictionary * dicForAddPri = [[NSMutableDictionary alloc]initWithDictionary:dicOrModel];
    for (NSString * key in [[wModel class] wPrimaryKeys])
    {
        id value = [wModel valueForKey:key];
        if (key.length && value)
        {
            dicForAddPri[key] = value;
        }
    }
    NSString * SqlSelect = [self wGetSqlSelectWithWmodelDic:dicForAddPri
                                                  TableName:[[wModel class] wTableName]
                                                PrimaryKeys:[[wModel class] wPrimaryKeys]];
    return SqlSelect;
    
}
-(NSString *)wGetSqlSelectWithWmodelDic:(NSDictionary *)wModelDic TableName:(NSString *)tableName PrimaryKeys:(NSArray *)primaryKeys
{
    NSArray * priKeys = primaryKeys;
    NSDictionary * dicForDbModel = wModelDic;
    NSMutableString * sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ %@",tableName,primaryKeys.count?@"WHERE ":@""];
    Boolean isAddAnd = NO;
    
    for (NSString * keyName in priKeys)
    {
        if (isAddAnd) {
            [sql appendString:@" AND "];
        }
        
        NSObject * value = [dicForDbModel objectForKey:keyName];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [sql appendFormat:@"%@ = \'%@\'",keyName,value];
            }else
            {
                [sql appendFormat:@"%@ = %@",keyName,value];
            }
        }
        isAddAnd = YES;
    }
    return sql;
}



#pragma mark - 验证

//判断是不是主键
-(Boolean)isPrimaryKeyWithString:(NSString *)primaryName PrimaryKey:(NSArray *)primaryKeys
{
    Boolean isKey = NO;
    for (NSString * primaryKey in primaryKeys) {
        if ([primaryName isEqualToString:primaryKey]) {
            isKey = YES;
            break;
        }
    }
    return isKey;
}

#pragma mark - 打印数据库错误
- (BOOL)showErrorMessage:(BOOL)isSuccess db:(FMDatabase *)db {
    if (!isSuccess) {
        NSLog(@"database error : %@",[db lastErrorMessage]);
    }
    return isSuccess;
}


@end

