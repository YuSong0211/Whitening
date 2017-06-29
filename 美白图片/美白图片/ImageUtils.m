
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
///打马赛克
+(UIImage*)imageMosaicProcess:(UIImage *)image{
    
    //第一步：获取图片的大小
    CGImageRef imageRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    //第二部：创建颜色空间（明确图片什么类型）
    //彩色图片、灰色图片
    //查看OpenCV源码实现（预览源码）
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    //第三步：创建图片上下文
    CGContextRef contectRef = CGBitmapContextCreate(nil, width, height, 8, width * 4,colorSpace, kCGImageAlphaPremultipliedLast);
    
    //第四部：根据图片上下文，绘制图片
    CGContextDrawImage(contectRef, CGRectMake(0, 0, width, height), imageRef);
    //第五步：根据图片上下文，获取图片
    unsigned char* imageData = (unsigned char*)CGBitmapContextGetData(contectRef);
    
    //第六步 开始图像处理-》打码处理
    
    int currentIndex = 0 , preIndex = 0;
    
    int level = 10;
    //定义一个像素数组。用于保存像素点的值（ARGB）
    unsigned char pixels[4] = {0};
    
    for (int i = 0; i < height - 1; i++) {
        for (int j = 0; j < width; j++) {
            //计算当前遍历位置
            currentIndex = i * width + j;
            //首先获取马赛克点第一行第一列的像素
            if (i % level == 0 ) {
                if (j % level == 0) {
                    
                    memcpy(pixels, imageData + 4 * currentIndex, 4);
                }else{
                    //其他列
                    memcpy(imageData + 4 * currentIndex,pixels, 4);
                }
            }else{
                
                preIndex = (i - 1) * width + j;
                
                memcpy(imageData + 4 * currentIndex, imageData  + 4 * preIndex, 4);
                
            }
            
        }
    }
    
    //第七步：获取图片数据集合
    CGDataProviderRef providerRef = CGDataProviderCreateWithData(nil, imageData, width * height * 4, NULL);
    //第八步：创建马赛克图片
    CGImageRef  mosaicImageRef = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, kCGImageAlphaPremultipliedLast, providerRef, NULL, NO, kCGRenderingIntentDefault);
    //第九步创建输出图片
    CGContextRef outputContextRef = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace , kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContextRef, CGRectMake(0, 0, width, height), mosaicImageRef);
    CGImageRef outputImageRef = CGBitmapContextCreateImage(outputContextRef);
    UIImage * outputImage = [UIImage imageWithCGImage:outputImageRef];;
    
    //第十步：释放内存
    CGImageRelease(outputImageRef);
    CGImageRelease(mosaicImageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(providerRef);
    CGContextRelease(contectRef);
    CGContextRelease(outputContextRef);
    
    return outputImage;
}


@end
