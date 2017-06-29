//
//  ImageUtils.h
//  美白图片
//
//  Created by  椒徒科技 on 2017/6/27.
//  Copyright © 2017年 jiaotukeji. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageUtils : NSObject
//美白

+(UIImage *)imageProcess:(UIImage*)image;

//马赛克
+(UIImage*)imageMosaicProcess:(UIImage *)image;
@end
