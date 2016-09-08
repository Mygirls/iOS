//
//  DataService.m
//  WGZY
//
//  Created by mjq on 15/6/9.
//  Copyright (c) 2015年 mjq. All rights reserved.
//

#import "DataService.h"


//@"http://115.159.82.101:8088/baiYiMaoMobile/Product/"
//#define BASE_URL @"http://115.159.82.101:8088/baiYiMaoMobile/Product/"

#define BASE_URL @"http://192.168.0.109:8080/baiYiMaoMobile/Product/"

@implementation DataService



+ (void)requestURL:(NSString *)urlstring
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)params
       complection:(void(^)(id result))block {
    
    //1.构造URL
    urlstring = [BASE_URL stringByAppendingString:urlstring];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    //2.构造request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:method];
    
    //1>拼接请求参数:username=wxhl&password=123456&key=value&....
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
        //http://wxhl.com/search?q=tttt&
        
        NSString *separe = url.query?@"&":@"?";
        NSString *paramsURL = [NSString stringWithFormat:@"%@%@%@",urlstring,separe,paramsString];
        
        request.URL = [NSURL URLWithString:paramsURL];
    }
    else if([method isEqualToString:@"POST"]) {
        
        NSData *bodyData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    
    //3.构造连接对象
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
//            NSLog(@"网络请求失败 : %@",connectionError);
            return ;
        }
        
        //1.解析JSON
        // JSON字符串 ---> 字典、数组
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //2.回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //回调block
            block(result);
            
        });
        
    }];
    
}



@end
