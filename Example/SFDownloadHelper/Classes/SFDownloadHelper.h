//
//  SFDownloadHelper.h
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFDownloadHelperState) {
    /** 暂停 */
    SFDownloadHelperStatePasue,
    /** 下载中 */
    SFDownloadHelperStateDownloading,
    /** 成功 */
    SFDownloadHelperStateSuccess,
    /** 失败 */
    SFDownloadHelperStateFailed,
    /** 取消 */
    SFDownloadHelperStateCancle
};


typedef void(^SFDownloadFileInfo)(long long totalSzie);

typedef void(^SFDownloadCompletion)(NSString * _Nullable filePath, NSError * _Nullable  error);
@class SFDownloadHelper;
@protocol SFDownloadHelperDelegate <NSObject>
/// 回调下载状态
- (void)downloadHelper:(SFDownloadHelper *)helper didChangeState:(SFDownloadHelperState)state;
/// 回调下载进度
- (void)downloadHelper:(SFDownloadHelper *)helper didChangeProgress:(CGFloat)progress;
@end





@interface SFDownloadHelper : NSObject

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


#pragma mark -
#pragma mark - ===== 属性 =====
/// 下载状态
@property (nonatomic, assign,readonly) SFDownloadHelperState state;
/// 下载进度
@property (nonatomic, assign,readonly) CGFloat progress;
/// 代理回调下载进度,下载状态等
@property (nonatomic, weak) id<SFDownloadHelperDelegate> delegate;
/// 任务完成路径,无论成功或失败
@property (nonatomic, copy) SFDownloadCompletion completeHandel;
/// 获取文件总大小
@property (nonatomic, copy) SFDownloadFileInfo fileInfo;
@end

NS_ASSUME_NONNULL_END

