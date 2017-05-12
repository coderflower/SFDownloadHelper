//
//  SFDownLoadHelper.m
//  SFDownloadHelper
//
//  Created by 花菜 on 2017/5/13.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import "SFDownLoadHelper.h"
#import "NSString+SFMD5.h"
@interface SFDownLoadHelper ()<NSCopying, NSMutableCopying>
@property (nonatomic, strong) NSMutableDictionary * downloadInfo;
@property (nonatomic, strong) NSMutableArray * taskUrls;
@end
@implementation SFDownLoadHelper

static SFDownLoadHelper * _sharedHelper = nil;
+ (instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[self alloc] init];
    });
    return _sharedHelper;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_sharedHelper)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedHelper = [super allocWithZone:zone];
        });
    }
    return _sharedHelper;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _sharedHelper;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _sharedHelper;
}




/**
 根据一个 url 连接执行下载任务
 
 @param url  URL
 */
- (void)downloadWithURL:(NSURL *)url
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    SFDownloader * downloader = [self downloaderWithUrlMd5:urlMd5];
    [downloader downloadWithURL:url];
}

/**
 根据一个 url 连接执行下载任务
 
 @param url url
 @param info 文件信息回调
 @param completeHandle 完成回调
 */
- (void)downloadWithURL:(NSURL *)url info:(SFDownloadFileInfo)info completeHandle:(SFDownloadCompletion)completeHandle
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    SFDownloader * downloader = [self downloaderWithUrlMd5:urlMd5];
    
    __weak typeof(self) wself = self;
    [downloader downloadWithURL:url info:info completeHandle:^(NSString * _Nullable filePath, NSError * _Nullable error) {
        if (!error)
        {
            // 下载成功移除下载器
            [wself.downloadInfo removeObjectForKey:urlMd5];
        }
        completeHandle(filePath,error);
    }];
}


- (SFDownloader *)downloaderWithUrlMd5:(NSString *)urlMd5
{
    
    [self.taskUrls addObject:urlMd5];
    SFDownloader * downloader = [self.downloadInfo objectForKey:urlMd5];
    
    if (!downloader)
    {
        downloader = [[SFDownloader alloc] init];
        [self.downloadInfo setObject:downloader forKey:urlMd5];
    }
    return downloader;
}
/**
 暂停当前 url 对应的任务
 
 @param url url
 */
- (void)pasueCurrentTaskWithURL:(NSURL *)url
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    
    SFDownloader * downloader = [self.downloadInfo objectForKey:urlMd5];
    
    [downloader pasueCurrentTask];
}

/**
 恢复当前 url 对应的任务
 
 @param url url
 */
- (void)resumeCurrentTaskURL:(NSURL *)url
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    
    SFDownloader * downloader = [self.downloadInfo objectForKey:urlMd5];
    
    [downloader resumeCurrentTask];
}

/**
 取消当前 url 对应的任务
 
 @param url url
 */
- (void)cancleCurrentTaskURL:(NSURL *)url
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    
    SFDownloader * downloader = [self.downloadInfo objectForKey:urlMd5];
    
    [downloader cancleCurrentTask];
}

/**
 取消当前 url 对应的任务并删除已下载的文件
 
 @param url url
 */
- (void)cancleAndClearCurrentTaskURL:(NSURL *)url
{
    NSString * urlMd5 = [url.absoluteString sf_md5];
    
    SFDownloader * downloader = [self.downloadInfo objectForKey:urlMd5];
    
    [downloader cancleAndClearCurrentTask];
}

/**
 暂停所有任务
 */
- (void)pasueAllTask
{
    [self.downloadInfo.allValues makeObjectsPerformSelector:@selector(pasueCurrentTask) withObject:nil];
}

/**
 取消所有任务
 */
- (void)cancleAllTask
{
    [self.downloadInfo.allValues makeObjectsPerformSelector:@selector(resumeCurrentTask) withObject:nil];
}

- (NSMutableDictionary *)downloadInfo
{
    if (!_downloadInfo)
    {
        _downloadInfo = [[NSMutableDictionary alloc] init];
    }
    return _downloadInfo;
}

- (NSMutableArray *)taskUrls
{
    if (!_taskUrls)
    {
        _taskUrls = [[NSMutableArray alloc] init];
    }
    return _taskUrls;
}
@end
