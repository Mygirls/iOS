//
//  AppDelegate.m
//  启动图片
//
//  Created by administrator on 16/9/7.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashScreenView.h"
#import "SplashScreenDataManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    
//    [_window makeKeyWindow];
    
    //1.启动页停留1秒
    [NSThread sleepForTimeInterval:1];
    
    
    // 1.判断沙盒中是否存在广告图片
    NSString *filePath = [SplashScreenDataManager getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    
    BOOL isExist = [SplashScreenDataManager isFileExistWithFilePath:filePath];
    NSLog(@"%hhd  %@ %@",isExist,[[NSUserDefaults standardUserDefaults] valueForKey:adDeadline],filePath);
    if (isExist) {
        // 图片存在
        SplashScreenView *advertiseView = [[SplashScreenView alloc] initWithFrame:self.window.bounds];
        advertiseView.imgFilePath = filePath;
        advertiseView.imgLinkUrl = [[NSUserDefaults standardUserDefaults] valueForKey:adUrl];
        advertiseView.imgDeadline = [[NSUserDefaults standardUserDefaults] valueForKey:adDeadline];
        //        设置广告页显示的时间
        [advertiseView showSplashScreenWithTime:3];
        
    }
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [SplashScreenDataManager getAdvertisingImageData];
    
    return YES;
}


@end
