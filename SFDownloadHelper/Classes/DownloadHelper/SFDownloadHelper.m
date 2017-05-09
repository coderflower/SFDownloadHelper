//
//  SFDownloadHelper.m
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import "SFDownloadHelper.h"

#define SFCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define SFTmpPath NSTemporaryDirectory()
@interface SFDownloadHelper()<NSURLSessionDataDelegate>
{
    long long _tmpSize;
    long long _totalSize;
}
@property (nonatomic, strong) NSURLSession * session;
@end
@implementation SFDownloadHelper

#pragma mark -
#pragma mark - =============== 公开方法 ===============
- (void)downloadWithURL:(NSURL *)url
{
    // 获取文件名
    // 判断文件是否存在 cache 目录下
    
    
}
#pragma mark -
#pragma mark - =============== 私有方法 ===============
- (void)downloadWithURL:(NSURL *)url offset:(long long)offset
{

}
#pragma mark -
#pragma mark - =============== NSURLSessionDataDelegate ===============
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{

}
/**
 下载完成回调，不论成功失败都会调用

 @param session session
 @param task task
 @param error error
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{

}
#pragma mark -
#pragma mark - =============== getter ===============
- (NSURLSession *)session
{
    if (!_session)
    {
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
