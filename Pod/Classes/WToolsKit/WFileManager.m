//
//  SandboxManager.m
//
//
//  Created by Linjw on 13-8-28.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "WFileManager.h"
#include "sys/stat.h"
#include <dirent.h>

@implementation WFileManager

#pragma mark - Plist文件读写

+(BOOL)wWriteDicToFileInDocumentDir:(NSDictionary *)dic FileName:(NSString *)fileNameInDocumentDir
{
    NSString * path = [[self class] wFilePathInDir:[[self class] wDocumentDirPath] FileName:fileNameInDocumentDir IsCreateIfNoExist:NO];
    return [[self class] wWriteDicToFile:dic FilePath:path];
    
}


+(NSDictionary *)wReadDicFromFileInDocumentDirWithFileName:(NSString *)fileNameInDocumentDir
{
    NSString * path = [[self class] wFilePathInDir:[[self class] wDocumentDirPath] FileName:fileNameInDocumentDir IsCreateIfNoExist:NO];
    return [[self class] wReadDicFromFilePath:path];
}

+(BOOL)wWriteDicToFile:(NSDictionary *)dic FilePath:(NSString *)filePath
{
    return [dic writeToFile:filePath atomically:YES];
}

+(NSDictionary *)wReadDicFromFilePath:(NSString *)filePath
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic == nil) {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

#pragma mark - NSUserDefaults
+ (id)wObjectFromNSUserDefaultsWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)wSetObjectToNSUserDefaultsWithDic:(NSDictionary *)dicForObjectWithKey
{
    if (dicForObjectWithKey && dicForObjectWithKey.allKeys.count) {
        NSArray * keys = [dicForObjectWithKey allKeys];
        for (NSString * key in keys)
        {
            id object = [dicForObjectWithKey objectForKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        NSLog(@"没有设置写入到UserDefault的dic");
    }
}

+ (void)wSetObjectForNSUserDefaultsWithObject:(id)object Key:(NSString *)key
{
    if (object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - NSBundle
//得到BundleInfo
+(NSDictionary *)wBundleInfoDictionary
{
    return [[NSBundle mainBundle] infoDictionary];
}

//APP版本
+(NSString *)wAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

#pragma mark - 文件夹

//得到Home路径
+(NSString *)wHomeDirPath
{
    return NSHomeDirectory();
}

//得到Document路径
+(NSString *)wDocumentDirPath
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [Paths objectAtIndex:0];
    return path;
}

//获取Cache目录路径
+(NSString *)wCacheDirPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

//获取Library目录路径
+(NSString *)wLibraryDirPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

//获取Temp目录路径
+(NSString *)wTempDirPath
{
    return NSTemporaryDirectory();
}


//superDirPath下dirName目录的具体路径
+(NSString *)wDirPathInSuperDirPath:(NSString *)superDirPath DirName:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    NSError * error = nil;
    NSString * path = [superDirPath stringByAppendingPathComponent:dirName];
    
    if (isCreateIfNoExist)
    {
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"create dir error: %@",error.localizedDescription);
        }
    }
    return path;
}

//返回Documents下的指定文件(夹)路径
+(NSString *)wDirPathInDocuments:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wDirPathInSuperDirPath:[[self class] wDocumentDirPath] DirName:dirName IsCreateIfNoExist:isCreateIfNoExist];
}

//返回Library下的指定文件夹路径
+(NSString *)wDirPathInLibrary:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wDirPathInSuperDirPath:[[self class] wLibraryDirPath] DirName:dirName IsCreateIfNoExist:isCreateIfNoExist];

}

//返回Cache下的指定文件夹路径
+(NSString *)wDirPathInCaches:(NSString *)dirName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wDirPathInSuperDirPath:[[self class] wCacheDirPath] DirName:dirName IsCreateIfNoExist:isCreateIfNoExist];
}


//返回指定目录下的子文件夹或文件的路径
+(NSArray *)wSubPathInDir:(NSString *)dirPath
{
    NSFileManager * fileManage = [NSFileManager defaultManager];
    NSArray * file = [fileManage subpathsAtPath:dirPath];
    return file;
}

+(NSString *)wFileSizeString:(long long int )size
{
    if(size >=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",(CGFloat)size/1024/1024];
    }
    else if(size>=1024&&size<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",(CGFloat)size/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",(CGFloat)size];
    }
}

+(float)wFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+(long long)wDirSizeAtDirPath:(NSString *)dirPath
{
    const char * folderPath = [dirPath cStringUsingEncoding:NSUTF8StringEncoding];
    return [[self class] cGetDirSizeAtPath:folderPath];
}

+ (long long) cGetDirSizeAtPath: (const char *)folderPath
{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent * child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && ((child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        unsigned long folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self cGetDirSizeAtPath:childPath]; // 递归调用得到子目录大小，并加上去
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}


#pragma mark - 文件

+(NSString *)wFilePathInDir:(NSString *)dirPath FileName:(NSString *)fileName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    NSString * path = [dirPath stringByAppendingPathComponent:fileName];
    if (isCreateIfNoExist)
    {
        NSFileManager * fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path])
        {
            [fm createFileAtPath:path contents:nil attributes:nil];
        }
    }
    return path;
}

//得到Document目录下的文件fileName的路径
+(NSString *)wFilePathInDocumentDirWithFileName:(NSString *)fileName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wFilePathInDir:[[self class] wDocumentDirPath] FileName:fileName IsCreateIfNoExist:isCreateIfNoExist];
}

//得到Library目录下的文件fileName的路径
+(NSString *)wFilePathInLibraryDirWithFileName:(NSString *)fileName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
        return [[self class] wFilePathInDir:[[self class] wLibraryDirPath] FileName:fileName IsCreateIfNoExist:isCreateIfNoExist];
}

//得到Cache目录下的文件fileName的路径
+(NSString *)wFilePathInCacheDirWithFileName:(NSString *)fileName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wFilePathInDir:[[self class] wCacheDirPath] FileName:fileName IsCreateIfNoExist:isCreateIfNoExist];
}

//得到Temp目录下的文件fileName的路径
+(NSString *)wFilePathInTempDirWithFileName:(NSString *)fileName IsCreateIfNoExist:(BOOL)isCreateIfNoExist
{
    return [[self class] wFilePathInDir:[[self class] wTempDirPath] FileName:fileName IsCreateIfNoExist:isCreateIfNoExist];
}

//返回指定目录下的文件的所有文件名
+(NSArray *)wFileNamesInDir:(NSString *)dirPath
{
    NSError * error = nil;
    NSMutableArray * names = nil;
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * arrPathForSubPath =  [fm contentsOfDirectoryAtPath:dirPath error:&error];
    if (arrPathForSubPath.count)
    {
        names = [NSMutableArray arrayWithCapacity:0];
    }
    
    for (NSString * str in arrPathForSubPath)
    {
        NSString * path = [dirPath stringByAppendingPathComponent:str];
        BOOL isDir;
        [fm fileExistsAtPath:path isDirectory:&isDir];
        if (!isDir)
        {
            NSString *  fileName = [str lastPathComponent];
            [names addObject:fileName];
        }
    }
    return names;
}

//得到NSBundle下文件路径
+(NSString *)wFilePathInBundleResource:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                         ofType:[fileName pathExtension]];
    return filePath;
}

//调用C语言方法得到文件大小
+ (long long) wSizeForFileAtPath:(NSString*) filePath
{
    long long size = 0;
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0)
        size = st.st_size;
    return size;
}

#pragma mark - 其他

//得到某个路径的类型
+(FileOrDirectoryFlag)wFlagFileOrDirectoryWithPath:(NSString *)path
{
    FileOrDirectoryFlag fileFlag = FileOrDirectoryFlag_NoExist;
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fm fileExistsAtPath:path isDirectory:&isDir];
    fileFlag = isExist?isDir:FileOrDirectoryFlag_NoExist;
    return fileFlag;
}

//判断文件是否存在
+(BOOL)wIsExistFileWithPath:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

//删除某个文件
+(BOOL)wDeleteFileWithFilePath:(NSString *)filePath
{
    NSFileManager * fm = [NSFileManager defaultManager];
    Boolean isOK = YES;
    NSError * error = nil;
    isOK = [fm removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"Error For removefile : %@",error.localizedDescription);
    }
    return isOK;
}

//复制文件
+ (BOOL)wCopyFileWithAFilePath:(NSString *)filePath ToFilePath:(NSString *)toFilePath
{
    NSFileManager * fm = [NSFileManager defaultManager];
    Boolean isOK = YES;
    NSError * error = nil;
    isOK =[fm copyItemAtPath:filePath toPath:toFilePath error:&error];
    if (error) {
        NSLog(@"Error For copy file : %@",error.localizedDescription);
    }
    return isOK;
}

@end

