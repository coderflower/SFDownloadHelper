//
//  SFViewController.m
//  SFDownloadHelper
//
//  Created by chriscaixx on 05/09/2017.
//  Copyright (c) 2017 chriscaixx. All rights reserved.
//

#import "SFViewController.h"
#import "SFFileHelper.h"
#import "SFDownloadHelper.h"
@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString * path = @"/Users/Caiflower/Desktop/（moquu.com分享）极客学院小程序视频教程/1.1微信小程序从基础到实战课程概要.mp4";
    
    NSLog(@"%lld",[SFFileHelper sf_fileSizeInPath:path]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSURL * url = [NSURL URLWithString:@"https://fir.im/mfba"];
    
    
    [[SFDownloadHelper new] downloadWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
