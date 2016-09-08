//
//  SplashScreenDataManager.m
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/29.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "SplashScreenDataManager.h"
#import "SplashScreenView.h"
#import "WLXDataService.h"
#import <AdSupport/AdSupport.h> /*  idfa  */

@implementation SplashScreenDataManager
/**
 *  判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    

    
}

/**
 *  初始化广告页面1.1
 */
+ (void)getAdvertisingImageData
{
    
    [self getDataOfInfo];
    
}

/**
 *  初始化广告页面1.2 - 网络请求
 */
+ (void)getDataOfInfo
{
    __weak typeof(self) weakSelf = self;
    NSString *adId =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString *str = [NSString stringWithFormat:  @"{\"type\":\"%@\",\"imei\":\"%@\"}",@"0",adId];
    [params setObject:str forKey:@"parameters"];
    
    [self requestURL:@"startPage" httpMethod:@"POST" params:params complection:^(id result) {
        
        if ([[result objectForKey:@"end"] isEqualToString:@"ok"]  ) {//请求数据ok
            
            NSArray *list = [result objectForKey:@"list"];
            NSDictionary *imgDic= [list firstObject];
            
            //启动图片url
            NSString *imageUrl = [imgDic objectForKey:@"imgUrl"];;
            //点击广告的进入页面的url
            NSString  *imgLinkUrl = @"http://www.jianshu.com/users/e4c63b354a77/latest_articles";
            
            //截止日期
            NSString  *imgDeadline =  @"09/30/2016 14:25";
            
            // 获取图片名
            NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
            NSString *imageName = stringArr.lastObject;
            
            [weakSelf TheDataOfAdImageWithUrl:imageUrl imageName:imageName imgLinkUrl:imgLinkUrl imgDeadline:imgDeadline];
            
        }else {//请求数据error
            NSString * imgLinkUrl = [[NSUserDefaults standardUserDefaults] valueForKey:adUrl];
            NSString * imgDeadline = [[NSUserDefaults standardUserDefaults] valueForKey:adDeadline];
            NSString * imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
            NSString * imageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:laughUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [weakSelf TheDataOfAdImageWithUrl:imageUrl imageName:imageName imgLinkUrl:imgLinkUrl imgDeadline:imgDeadline];

        }
     
    }];
}

/**
 *  初始化广告页面1.3
 */
+  (void)TheDataOfAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName imgLinkUrl:(NSString *)imgLinkUrl imgDeadline:(NSString *)imgDeadline
{
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName imgLinkUrl:imgLinkUrl imgDeadline:imgDeadline];
        
    }
}




/**
 *  下载新的图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName imgLinkUrl:(NSString *)imgLinkUrl imgDeadline:(NSString *)imgDeadline
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        [UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES];
        if ([UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES]) {
            
            // 保存成功
            //判断保存下来的图片名字和本地沙盒中存在的图片是否一致，如果不一致，说明图片有更新，此时先删除沙盒中的旧图片，如果一致说明是删除缓存后再次下载，这时不需要进行删除操作，否则找不到已保存的图片
            if (![imageName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:adImageName] ]) {
                [self deleteOldImage];
            }
           
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] setValue:imgLinkUrl forKey:adUrl];
            [[NSUserDefaults standardUserDefaults] setValue:imgDeadline forKey:adDeadline];
            [[NSUserDefaults standardUserDefaults] setValue:imageUrl forKey: laughUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            NSLog(@"保存失败");
        }
        
    });
}




/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
    
    if (imageName) {
        
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adImageName];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adUrl];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adDeadline];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName

{
    
    if (imageName) {
        
        NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
        NSString *filePath = [paths stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


/**
 *  网络请求
 */
+ (void)requestURL:(NSString *)urlstring
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)params
       complection:(void(^)(id result))block {
    
    /** 1.构造URL 转化为URL **/
    urlstring = [@"https://b.baiyimao.com/baiYiMaoMobile_b/Product/" stringByAppendingString:urlstring];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    /** 2.构造request 根据 baseURL 创建网络请求对象 **/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60];
    
    /** 3.设置参数：1.POST 2.参数体（body）**/
    [request setHTTPMethod:method];
    
    /** 4.拼接请求参数:username=wxhl&password=123456&key=value&.... **/
    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allKeys = params.allKeys;
    for (int i=0; i<params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramsString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    //2>添加请求参数:
    /*
     请求参数的格式1： username=wxhl&password=123456&key=value&....
     请求参数的格式2 JSON：{username:wxhl,password:12345,....}
     */
    //将字典 ----> JSON字符串
    
    //    //JSONKit
    //    NSString *jsonString = [params JSONString];
    //    NSLog(@"%@",jsonString);
    
    
    /**
     *  判断请求方式：
     GET ： 参数拼接在URL后面
     POST ： 参数添加到请求体中
     */
    if ([method isEqualToString:@"GET"]) {
        //http://baiyimao.com/search?q=tttt&
        
        NSString *separe = url.query?@"&":@"?";
        NSString *paramsURL = [NSString stringWithFormat:@"%@%@%@",urlstring,separe,paramsString];
        request.URL = [NSURL URLWithString:paramsURL];
    }
    else if([method isEqualToString:@"POST"]) {
        /** 6.设置body参数  **/
        NSData *bodyData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    
    /** 7.<iOS 9>提供了 NSURLSession 来代替  NSURLConnection **/
    //首先，创建一个 NSURLSession 对象（如果要使用block来完成网络请求，这个对象可以使用 NSURLSession 自带的单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
    
    /** 8.session发送网络请求对象  **/
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        
        //8.1.回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            //回调block
            block(dict);
            
        });
        
    }];
    
    /** 9.开始网络请求任务(必须要) **/
    [task resume];
}






@end
