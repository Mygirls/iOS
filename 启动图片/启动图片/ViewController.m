//
//  ViewController.m
//  启动图片
//
//  Created by administrator on 16/9/7.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//

#import "ViewController.h"
#import "ADDetailViewController.h"
#import <AdSupport/AdSupport.h>

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    启动页中的广告页的监听事件，当点击了广告页时，跳转到相应的页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAdVC:) name:@"tapAction" object:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame= CGRectMake((self.view.frame.size.width - 100)/2, 100, 100, 40);
    [button setTitle:@"清除缓存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)buttonAction{
    
    //获取完整路径
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"Caches"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *fileNameAray = [manager subpathsAtPath:path];
        for (NSString *fileName in fileNameAray) {
            //拼接绝对路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            
            //通过文件管理者删除文件
            [manager removeItemAtPath:absolutePath error:nil];
            
            
        }
        NSLog(@"清除成功");
    }
    
    
}
- (void)pushToAdVC:(NSNotification *)notification {
    
    ADDetailViewController *adVc = [[ADDetailViewController alloc] init];
    adVc.URLString = notification.object;
    [adVc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:adVc animated:YES];
    
    [self presentViewController:adVc animated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tapAction" object:nil];
}


@end
