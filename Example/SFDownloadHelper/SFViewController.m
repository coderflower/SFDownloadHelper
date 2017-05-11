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
@property (nonatomic, strong) SFDownloadHelper * helper;
@property (nonatomic, strong) NSURL * url ;
@property (nonatomic, weak) NSTimer * timer;
@end

@implementation SFViewController

- (NSTimer *)timer
{
    if (!_timer)
    {
        NSTimer * timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSString * path = @"/Users/Caiflower/Desktop/（moquu.com分享）极客学院小程序视频教程/1.1微信小程序从基础到实战课程概要.mp4";
//    
//    NSLog(@"%lld",[SFFileHelper sf_fileSizeInPath:path]);
    _helper = [SFDownloadHelper new];
    _url = [NSURL URLWithString:@"http://downmobile.kugou.com/upload/ios_beta/kugou.ipa"];
    
}

- (void)updateTimer
{
    NSLog(@"%zd",self.helper.state);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self timer];
    
    
}
- (IBAction)start:(id)sender {
    [self.helper downloadWithURL:self.url];
    
}
- (IBAction)pasue:(id)sender {
    [self.helper pasueCurrentTask];
}
- (IBAction)cancel:(id)sender {
    [self.helper cancleCurrentTask];
}
- (IBAction)clear:(id)sender {
    [self.helper cancleAndClearCurrentTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
