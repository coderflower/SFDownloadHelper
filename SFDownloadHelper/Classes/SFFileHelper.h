//
//  SFFileHelper.h
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import <Foundation/Foundation.h>

@interface SFFileHelper : NSObject

/**
 判断文件是否存在

 @param filePath 文件目录
 @return 是否存在
 */
+ (BOOL)sf_flieExistsAtPath:(NSString *)filePath;

/**
 删除某个目录

 @param filePath 目录
 */
+ (void)sf_removeItemAtPath:(NSString *)filePath;

/**
 移动某个目录到另一个目录

 @param fromPath 被移动的目录
 @param toPath 目标目录
 */
+ (void)sf_moveItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 计算文件夹大小

 @param filePath 文件夹路径
 @return 大小 byte
 */
+ (long long)sf_fileSizeInPath:(NSString *)filePath;
@end
