//
//  Color.h
//  美白图片
//
//  Created by  椒徒科技 on 2017/6/27.
//  Copyright © 2017年 jiaotukeji. All rights reserved.
//

#ifndef Color_h
#define Color_h
//定义宏用来获取ARGB分量值
#define Mask8(x) ((x) & 0xFF)
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >>8 ) )
#define B(x) ( Mask8(x >>16) )
#define A(x) ( Mask8(x >>24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24)

#endif /* Color_h */
