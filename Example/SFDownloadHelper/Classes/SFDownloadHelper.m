//
//  SFDownloadHelper.m
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import "SFDownloadHelper.h"

#import "SFFileHelper.h"

#define SFCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define SFTempPath NSTemporaryDirectory()
@interface SFDownloadHelper ()<NSURLSessionDataDelegate>
{
    NSString * _tmpPath;
    NSString * _cachesPath;
    long long _tmpSize;
    long long _totalSize;
}
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSOutputStream * outputStream;
@property (nonatomic, weak) NSURLSessionDataTask * task;
@end
@implementation SFDownloadHelper
- (void)downloadWithURL:(NSURL *)url
{
    // 获取文件名
    NSString * fileName = url.lastPathComponent;
    _cachesPath = [SFCachePath stringByAppendingPathComponent:fileName];
    // 判断是否下载完成
    if ([SFFileHelper sf_flieExistsAtPath:_cachesPath])
    {
        NSLog(@"文件下载完成");
        return;
    }
    // 判断是否曾经下载过
    _tmpPath = [SFTempPath stringByAppendingPathComponent:fileName];
    if ([SFFileHelper sf_flieExistsAtPath:_tmpPath])
    {
        // 获取已下载的文件大小
        _tmpSize = [SFFileHelper sf_fileSizeInPath:_tmpPath];
        [self downloadWithURL:url offset:_tmpSize];
    }
    else
    {
        // 从 0 开始下载
        [self downloadWithURL:url offset:0];
    }
    
}
- (void)pasueCurrentTask
{
    [self.task suspend];
}
- (void)cancleCurrentTask
{
    [self.session invalidateAndCancel];
    self.session = nil;
}
- (void)cancleAndClearCurrentTask
{
    [self cancleCurrentTask];
    // 删除缓存
    [SFFileHelper sf_removeItemAtPath:_tmpPath];
}

#pragma mark -
#pragma mark - ===== 私有方法 =====
- (void)downloadWithURL:(NSURL *)url offset:(long long)offset
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    // 设置起始下载字节
    NSString * offsetStr = [NSString stringWithFormat:@"byties=%lld",offset];
    [request setValue:offsetStr forHTTPHeaderField:@"Range"];
    
    self.task = [self.session dataTaskWithRequest:request];
    // 开始任务
    [self.task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSHTTPURLResponse * rsp = (NSHTTPURLResponse *)response;
    
    NSDictionary * fileInfo = rsp.allHeaderFields;
    
    _totalSize = [fileInfo[@"Content-Length"] longLongValue];
    NSString * contentRange = fileInfo[@"content-range"];
    // 获取真实大小
    NSString * totalSize = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    if ( totalSize.length != 0)
    {
        _totalSize = [totalSize longLongValue];
    }
    if (_tmpSize == _totalSize)
    {
        // 移动临时文件到 cache 目录
        [SFFileHelper sf_moveItemFromPath:_tmpPath toPath:_cachesPath];
      completionHandler(NSURLSessionResponseCancel);
        NSLog(@"下载完成");
        return;
    }
    if (_tmpSize > _totalSize)
    {
        completionHandler(NSURLSessionResponseCancel);
        NSLog(@"临时文件错误,重新下载");
        // 移除原有临时文件
        [SFFileHelper sf_removeItemAtPath:_tmpPath];
        // 重新开始下载
        [self downloadWithURL:response.URL];
        return;
    }
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:_tmpPath append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.outputStream write:data.bytes maxLength:data.length];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"任务完成%@",error);
    if (!error) {
        
    }
    else
    {
        NSLog(@"下载失败%@",error);
    }
}

- (NSURLSession *)session
{
    if (!_session)
    {
        NSURLSessionConfiguration  * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}




@end
