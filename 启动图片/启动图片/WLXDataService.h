//
//  WXDataService.h
//  WXWeibo
//
//  Created by Mac on 14-9-27.
//  Copyright (c) 2014年 com.wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CompletionLoad)(id result);

@interface WLXDataService : NSObject

//AFNetworking 3.0
+ (void)requestWithURL:(NSString *)url
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod
                 block:(CompletionLoad)block;

//AFNetworking 老版的
//+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
//                                    params:(NSMutableDictionary *)params
//                                httpMethod:(NSString *)httpMethod
//                                  block:(CompletionLoad)block;

@end
