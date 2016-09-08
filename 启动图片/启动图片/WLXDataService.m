

//
//  WXDataService.m
//  WXWeibo
//
//  Created by Mac on 14-9-27.
//  Copyright (c) 2014年 com.wxhl. All rights reserved.
//

#import "WLXDataService.h"


@implementation WLXDataService


//AFNetworking 3.0
+ (void)requestWithURL:(NSString *)url
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod
                 block:(CompletionLoad)block{
    //     内网 胖虎
//        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.0.199:8080/baiYiMaoMobile/Product/",url];
    
    //🐑哥
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.0.149:8087/baiYiMaoMobile/Product/",url];

    //    s.zhuofanbaobei.com" 2.14 张哥 测试 外网
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"https://s.zhuofanbaobei.com/baiYiMaoMobile/Product/",url];
    
    //3.0版本
//        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://s.baiyimao.com/baiYiMaoMobile/Product/",url];
    
    //3.1
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://b.baiyimao.com/baiYiMaoMobile_b/Product/",url];

    //3.1.1
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"https://s.baiyimao.com/baiYiMaoMobile/Product/",url];
    
    //3.2
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"https://b.baiyimao.com/baiYiMaoMobile_b/Product/",url];

    
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;

    if ([httpMethod isEqualToString:@"GET"]) {  // 如果是get请求
        // Get请求
        [manager GET:urlStr  parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 这里可以获取到目前的数据请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据 NSLog(@"%@", responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (block) {
                block(dic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (block) {//NSLog(@"%@", [error localizedDescription]);
                block(error);
            }
        }];
        
    }else if ([httpMethod isEqualToString:@"POST"]) {
        // post请求
        [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"%@",responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (block) {
                block(dic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (block) {//NSLog(@"%@", [error localizedDescription]);
                block(error);
            }
        }];
        

        // 使用下面这个方法时候 参数传不到服务器，会显示参数错误
//        [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
//            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
//            
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            // 这里可以获取到目前的数据请求的进度
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功，解析数据NSLog(@"%@", responseObject);
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//            if (block) {
//                block(dic);
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            if (block) {//NSLog(@"%@", [error localizedDescription]);
//                block(error);
//            }
//        }];
        
        
        
    }
}


/* 
 //AFNetworking 老版的
//https://open.weibo.cn/2/statuses/home_timeline.json?count=30&access_token=2.00K5Y5dCHUn2VD89b4f062ec07jLny
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                                     block:(CompletionLoad)block
{
    //1.配置AFNetworking需要使用的framework
    //2.拼接url
    //3.区分是get还是post
    //4.封装get和post请求
    //5.测试
    //http://192.168.0.140:8080/baiYiMaoMobile/Product/"
//雨阳
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.0.149:8087/baiYiMaoMobile/Product/",url];
//    NSLog(@"%@",urlStr);
//    115.159.82.101"  8181
    
//测试
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://m.zhuofanbaobei.com/baiYiMaoMobile/Product/",url];

    
//     内网 传虎
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.0.199:8080/baiYiMaoMobile/Product/",url];

    
//  外网
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://115.159.82.101:8181/baiYiMaoMobile/Product/",url];
    
    //s.zhuofanbaobei.com" 2.14 张哥 测试 外网
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"https://s.zhuofanbaobei.com/baiYiMaoMobile/Product/",url];
 
    // 锦豪  http://192.168.0.234/baiYiMaoMobile/Product/interface.jsp
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.0.234/baiYiMaoMobile/Product/",url];

    
    //3.0
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://s.baiyimao.com/baiYiMaoMobile/Product/",url];


    
    
    
    //真实外网 2.13
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://s.baiyimao.com/baiYiMaoMobile/Product/",url];

    //真实外网 2.14
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://b.baiyimao.com/baiYiMaoMobile_b/Product/",url];

    
    //测试
//    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://115.159.83.172:9080/baiYiMaoMobile/Product/",url];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *requestOperation = nil;
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    if ([httpMethod isEqualToString:@"GET"]) {  // 如果是get请求
        requestOperation = [manager GET:urlStr
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 application.networkActivityIndicatorVisible = NO;
            if (block) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"数据加载失败");
            application.networkActivityIndicatorVisible = NO;
            if (block) {
                block(error);
            }

        }];
    }else if ([httpMethod isEqualToString:@"POST"]){ // 如果是post请求,分2种情况:1.不带附件，2.带附件
        BOOL hasFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            if ([value isKindOfClass:[NSData class]]) {
                hasFile = YES;
                break;
            }
        }
        
        if (!hasFile) {  // 没有附件
            
            requestOperation = [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                application.networkActivityIndicatorVisible = NO;
                if (block) {
                    block(responseObject);
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                application.networkActivityIndicatorVisible = NO;
                NSLog(@"网络请求失败");
                NSLog(@"%@",operation);
                if (block) {
                    block(error);
                }
            }];
            
        }else{
            requestOperation = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                // 构造body,告诉AF是什么类型文件
                for (NSString *key in params) {
                    id value = params[key];
                    if ([value isKindOfClass:[NSData class]]) {
                        [formData appendPartWithFileData:value name:key fileName:key mimeType:@"image/jpeg"];
                    }
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                application.networkActivityIndicatorVisible = NO;
                if (block) {
                    block(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                application.networkActivityIndicatorVisible = NO;
                NSLog(@"网络请求失败");
                NSLog(@"%@",operation);
                if (block) {
                    block(error);
                }
            }];
        }
    }
    
    // 设置返回数据的解析方式
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    return requestOperation;
}
 
 */

@end
