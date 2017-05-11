//
//  SFDownloadHelper.h
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SFDownloadHelperState) {
    /** 暂停 */
    SFDownloadHelperStatePasue,
    /** 下载中 */
    SFDownloadHelperStateDownloading,
    /** 成功 */
    SFDownloadHelperStateSuccess,
    /** 失败 */
    SFDownloadHelperStateFaile,
    /** 取消 */
    SFDownloadHelperStateCancle
};
@interface SFDownloadHelper : NSObject

/**
 根据一个 url 连接执行下载任务

 @param url  URL
 */
- (void)downloadWithURL:(NSURL *)url;

/**
 暂停当前任务
 */
- (void)pasueCurrentTask;

/**
 取消当前任务
 */
- (void)cancleCurrentTask;

/**
 取消当前任务并删除已下载的文件
 */
- (void)cancleAndClearCurrentTask;

@property (nonatomic, assign) SFDownloadHelperState state;
@end
