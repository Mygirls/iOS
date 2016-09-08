//
//  DataService.h
//  WGZY
//
//  Created by mjq on 15/6/9.
//  Copyright (c) 2015年 mjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject




+ (void)requestURL:(NSString *)urlstring
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)params
       complection:(void(^)(id result))block;




@end
