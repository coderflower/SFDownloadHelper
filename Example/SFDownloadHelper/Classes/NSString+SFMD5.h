//
//  NSString+SFMD5.h
//  SFDownloadHelper
//
//  Created by 花菜 on 2017/5/13.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SFMD5)

/**
 获取字符串 MD5

 @return MD5
 */
- (NSString *)sf_md5;

/**
 获取文件 MD5 ,使用文件绝对路径来调用

 @return MD5
 */
- (NSString *)sf_fileMD5;
@end
