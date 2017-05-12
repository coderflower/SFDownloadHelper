//
//  SFDownLoadHelper.h
//  SFDownloadHelper
//
//  Created by 花菜 on 2017/5/13.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFDownloader.h"
@interface SFDownLoadHelper : NSObject

+ (instancetype)sharedHelper;
/**
 根据一个 url 连接执行下载任务
 
 @param url  URL
 */
- (void)downloadWithURL:(NSURL *)url;

/**
 根据一个 url 连接执行下载任务
 
 @param url url
 @param info 文件信息回调
 @param completeHandle 完成回调
 */
- (void)downloadWithURL:(NSURL *)url info:(SFDownloadFileInfo)info completeHandle:(SFDownloadCompletion)completeHandle;


/**
 暂停当前 url 对应的任务

 @param url url
 */
- (void)pasueCurrentTaskWithURL:(NSURL *)url;

/**
 恢复当前 url 对应的任务
 
 @param url url
 */
- (void)resumeCurrentTaskURL:(NSURL *)url;

/**
 取消当前 url 对应的任务
 
 @param url url
 */
- (void)cancleCurrentTaskURL:(NSURL *)url;

/**
 取消当前 url 对应的任务并删除已下载的文件
 
 @param url url
 */
- (void)cancleAndClearCurrentTaskURL:(NSURL *)url;

/**
 暂停所有任务
 */
- (void)pasueAllTask;

/**
 取消所有任务
 */
- (void)cancleAllTask;
@end
