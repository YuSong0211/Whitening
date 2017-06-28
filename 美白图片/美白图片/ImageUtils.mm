
//
//  ImageUtils.m
//  美白图片
//
//  Created by  椒徒科技 on 2017/6/27.
//  Copyright © 2017年 jiaotukeji. All rights reserved.
//


#import "ImageUtils.h"
#import "Color.h"


@implementation ImageUtils
+(UIImage *)imageProcess:(UIImage*)image{

    //第一步：确定图片大小
    NSUInteger width = CGImageGetWidth(image.CGImage);
    NSUInteger heiht = CGImageGetWidth(image.CGImage);
    //第二部：创建颜色空间
    CGColorSpaceRef colorspacce = CGColorSpaceCreateDeviceRGB();
    
    //第三部：创建图片上下文（作用：用于绘制图片、解析图片的信息）
    
    //数据源-->图片 --》像素数组---》像素点分量（ARGB）--->操作二进制
    UInt32 * imagePixels = (UInt32*)calloc(width * heiht, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePixels,
                                                    width,
                                                    heiht,
                                                    8,
                                                    4 * width,
                                                    colorspacce, kCGImageAlphaPremultipliedLast|
                                                    kCGBitmapByteOrder32Big);
    
    //第四部：根基图片上下文绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, heiht), image.CGImage);
    
    //第五步：开始进行图片操作
    //分析：美白--》操作图片--》操作像素数组--》造作像素点---》操作分量--》操作二进制--》修改二进制（修改分量值）
    
    int brightValue = 10;
    //循环遍历像素点（像素数组）
    for (int y = 0; y < heiht; y++) {
        for (int x = 0; x < width; x++) {
            
            //获取像素点的值
            //获取当前遍历的指针（指针位移获取）
            UInt32 * currentPixels = imagePixels + (y * width) + x;
            
            //获取指针像素点对于内存值（*取值 &取地址）
            UInt32 color = *currentPixels;
            //获取像素点的分量--->ARGB值---》二进制操作
            
            UInt32 thisR,thisG,thisB,thisA;
            
            //获取红色
            thisR = R(color);
            thisR = thisR + brightValue;
            thisR = thisR > 255 ? 255 :thisR;
        
            //获取红色
            thisG = G(color);
            thisG = thisG + brightValue;
            thisG = thisG > 255 ? 255 :thisG;
            //获取红色
            thisB = B(color);
            thisB = thisB + brightValue;
            thisB = thisB > 255 ? 255 :thisB;
            //获取红色
            thisA = A(color);
            
            //修改像素点
            *currentPixels = RGBAMake(thisR, thisG, thisB, thisA);
            
        }
    }
    //第六步：创建图片
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    
    //释放内存
    CGColorSpaceRelease(colorspacce);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    free(imagePixels);
    
    return newImage;
}

@end
