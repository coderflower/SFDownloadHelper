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
    if ([url isEqual:self.task.currentRequest.URL])
    {
        [self resumeCurrentTask];
        return;
    }
    // 获取文件名
    NSString * fileName = url.lastPathComponent;
    _cachesPath = [SFCachePath stringByAppendingPathComponent:fileName];
    // 判断是否下载完成
    if ([SFFileHelper sf_flieExistsAtPath:_cachesPath])
    {
        NSLog(@"文件下载完成");
        self.state = SFDownloadHelperStateSuccess;
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
    if (self.state == SFDownloadHelperStateDownloading )
    {
        [self.task suspend];
        self.state = SFDownloadHelperStatePasue;
    }
}
- (void)resumeCurrentTask
{
    if (self.task && (self.state == SFDownloadHelperStatePasue || self.state == SFDownloadHelperStateCancle))
    {
        [self.task resume];
        self.state = SFDownloadHelperStateDownloading;
    }
}
- (void)cancleCurrentTask
{
    self.state = SFDownloadHelperStateCancle;
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
   // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    // 设置起始下载字节
    NSString * offsetStr = [NSString stringWithFormat:@"bytes=%lld-",offset];
    [request setValue:offsetStr forHTTPHeaderField:@"Range"];
    
    self.task = [self.session dataTaskWithRequest:request];
    // 开始任务
    [self resumeCurrentTask];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获取本次下载期望大小
    _totalSize = response.expectedContentLength;
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse * rep = (NSHTTPURLResponse * )response;
        NSString * rangeStr = rep.allHeaderFields[@"content-range"];
        NSString * totalSize = [[rangeStr componentsSeparatedByString:@"/"] lastObject];
        if (totalSize.length != 0)
        {
            // 获取真实文件大小
            _totalSize = [totalSize longLongValue];
        }
        if (_tmpSize == _totalSize)
        {
            // 移动临时文件到 cache 目录
            [SFFileHelper sf_moveItemFromPath:_tmpPath toPath:_cachesPath];
            // 取消本次任务
            completionHandler(NSURLSessionResponseCancel);
            // 修改为下载完成状态
            self.state = SFDownloadHelperStateSuccess;
            return;
        }
        if (_tmpSize > _totalSize)
        {
            // 取消本次任务
            completionHandler(NSURLSessionResponseCancel);
            // 移除原有临时文件
            [SFFileHelper sf_removeItemAtPath:_tmpPath];
            // 重新开始下载
            [self downloadWithURL:response.URL];
            
            return;
        }
        // 创建输出流
        self.outputStream = [NSOutputStream outputStreamToFileAtPath:_tmpPath append:YES];
        // 开启输出流
        [self.outputStream open];
        // 修改为正在下载状态
        self.state = SFDownloadHelperStateDownloading;
        // 允许下载
        completionHandler(NSURLSessionResponseAllow);

    }
    else
    {
        // 取消
        completionHandler(NSURLSessionResponseCancel);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
    NSLog(@"正在写入数据");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"任务完成%@",error);
    if (!error)
    {
        // FIXME: - 需要验证文件完整性 MD5
        [SFFileHelper sf_moveItemFromPath:_tmpPath toPath:_cachesPath];
        self.state = SFDownloadHelperStateSuccess;
    }
    else
    {
        
        if (error.code == -999)
        {
            // 用户取消
            self.state = SFDownloadHelperStateCancle;
        }
        else
        {
            self.state = SFDownloadHelperStateFaile;
        }
        NSLog(@"下载失败%@",error);
    }
}

#pragma mark -
#pragma mark - ===== getter =====
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
