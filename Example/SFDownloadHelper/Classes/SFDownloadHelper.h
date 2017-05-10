//
//  SFDownloadHelper.h
//  Pods
//
//  Created by 花菜 on 2017/5/9.
//
//

#import <Foundation/Foundation.h>

@interface SFDownloadHelper : NSObject

/**
 根据一个 url 连接执行下载任务

 @param url  URL
 */
- (void)downloadWithURL:(NSURL *)url;
- (void)pasueCurrentTask;
- (void)cancleCurrentTask;
- (void)cancleAndClearCurrentTask;
@end
