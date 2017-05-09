//
//  SFFileHelper.m
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import "SFFileHelper.h"

@implementation SFFileHelper
+ (BOOL)sf_flieExistsAtPath:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}
+ (void)sf_removeItemAtPath:(NSString *)filePath
{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}
+ (void)sf_moveItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}
+ (long long)sf_fileSizeInPath:(NSString *)filePath
{
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    // 判断是否是文件夹
    if (isExist)
    {
        long long totalSize = 0;
        // 2. 判断是不是目录
        if (isDirectory)
        {
            NSArray * dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
            NSString * subPath = nil;
            // 遍历子目录递归计算文件大小
            for (NSString * str in dirArray) {
                subPath  = [filePath stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [[NSFileManager defaultManager] fileExistsAtPath:subPath isDirectory:&issubDir];
                totalSize += [self sf_fileSizeInPath:subPath];
            }
            return totalSize;
        }
        else
        {
            NSDictionary * fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            return [fileInfo[NSFileSize] longLongValue];
        }
    }
    else
    {
        NSLog(@"你打印的是目录或者不存在");
        return 0;
    }
}


@end
