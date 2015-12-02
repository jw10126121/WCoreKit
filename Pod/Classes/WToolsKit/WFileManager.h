//
//  SandboxManager.h
//
//
//  Created by Linjw on 13-8-28.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GetFilePathFromBundle(resource,type)    [[NSBundle mainBundle] pathForResource:resource ofType:type]
#define GetDocumentDirPath                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define GetFilePathInDocument(fileName)         [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]


typedef NS_ENUM(NSInteger, FileOrDirectoryFlag)//文件类型
{
    FileOrDirectoryFlag_File = 0,       //文件
    FileOrDirectoryFlag_Directory = 1,  //目录
    FileOrDirectoryFlag_NoExist = 2     //不存在
};

@interface WFileManager : NSObject

#pragma mark - Plist文件读写

//写入dic到DocumentDir目录下的fileNameInDocumentDir文件中
+(BOOL)wWriteDicToFileInDocumentDir:(NSDictionary *)dic FileName:(NSString *)fileNameInDocumentDir;

//从DocumentDir目录下读取fileNameInDocumentDir到dic中
+(NSDictionary *)wReadDicFromFileInDocumentDirWithFileName:(NSString *)fileNameInDocumentDir;

//写入dic到filePath下
+(BOOL)wWriteDicToFile:(NSDictionary *)dic FilePath:(NSString *)filePath;

//从filePath读取dic
+(NSDictionary *)wReadDicFromFilePath:(NSString *)filePath;

#pragma mark - NSUserDefaults
//根据key从NSUserDefaults得到相应对象
+ (id)wObjectFromNSUserDefaultsWithKey:(NSString *)key;

//写入多个数据到NSUserDefaults
+ (void)wSetObjectToNSUserDefaultsWithDic:(NSDictionary *)dicForObjectWithKey;

//写入数据到NSUserDefaults
+ (void)wSetObjectForNSUserDefaultsWithObject:(id)object Key:(NSString *)key;

#pragma mark - NSBundle
//得到BundleInfo
+(NSDictionary *)wBundleInfoDictionary;

//APP版本
+(NSString *)wAppVersion;

#pragma mark - 文件夹

//得到Home路径
+(NSString *)wHomeDirPath;

//得到Document路径
+(NSString *)wDocumentDirPath;

//获取Cache目录路径
+(NSString *)wCacheDirPath;

//获取Library目录路径
+(NSString *)wLibraryDirPath;

//获取Temp目录路径
+(NSString *)wTempDirPath;

//superDirPath下dirName目录的具体路径
+(NSString *)wDirPathInSuperDirPath:(NSString *)superDirPath DirName:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//返回Documents下的指定文件夹路径
+(NSString *)wDirPathInDocuments:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//返回Library下的指定文件夹路径
+(NSString *)wDirPathInLibrary:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//返回Cache下的指定文件夹路径
+(NSString *)wDirPathInCaches:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//返回指定目录下的子文件夹或文件的路径
+(NSArray *)wSubPathInDir:(NSString *)dirPath;

//得到文件夹SIZE
+ (long long) wDirSizeAtDirPath:(NSString*) dirPath;

+(NSString *)wFileSizeString:(long long int )size;

+(float)wFileSizeNumber:(NSString *)size;

#pragma mark - 文件

//得到dirPath目录下的文件fileName的路径
+(NSString *)wFilePathInDir:(NSString *)dirPath FileName:(NSString *)file IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//得到Document目录下的文件fileName的路径
+(NSString *)wFilePathInDocumentDirWithFileName:(NSString *)file IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//得到Library目录下的文件fileName的路径
+(NSString *)wFilePathInLibraryDirWithFileName:(NSString *)file IsCreateIfNoExist:(BOOL)isCreateIfNoExist;


//得到Cache目录下的文件fileName的路径
+(NSString *)wFilePathInCacheDirWithFileName:(NSString *)file IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//得到Temp目录下的文件fileName的路径
+(NSString *)wFilePathInTempDirWithFileName:(NSString *)file IsCreateIfNoExist:(BOOL)isCreateIfNoExist;

//返回指定目录下的文件的所有文件名
+(NSArray *)wFileNamesInDir:(NSString *)dirPath;

//得到NSBundle下文件路径
+(NSString *)wFilePathInBundleResource:(NSString *)file;

//得到文件大小
+ (long long) wSizeForFileAtPath:(NSString*) filePath;

#pragma mark - 其他

//得到某个路径的类型
+(FileOrDirectoryFlag)wFlagFileOrDirectoryWithPath:(NSString *)path;

//判断文件是否存在
+ (BOOL)wIsExistFileWithPath:(NSString *)filePath;

//删除某个文件
+ (BOOL)wDeleteFileWithFilePath:(NSString *)filePath;

//复制文件
+ (BOOL)wCopyFileWithAFilePath:(NSString *)filePath ToFilePath:(NSString *)toFilePath;





@end









