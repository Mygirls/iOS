//
//  SplashScreenDataManager.h
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/29.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SplashScreenDataManager : NSObject

@property(nonatomic, strong)NSArray *resultArray;
@property(nonatomic, strong) NSString *documentPath;
@property(nonatomic, strong) UIImageView *splashImageVeiw;
@property(nonatomic, copy)NSString *imageURL;

/**
 *  下载新的图片
 */
+(void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName imgLinkUrl:(NSString *)imgLinkUrl imgDeadline:(NSString *)imgDeadline;

/**
 *  判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;

/**
 *  初始化广告页面
 */
+(void)getAdvertisingImageData;

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;
@end
