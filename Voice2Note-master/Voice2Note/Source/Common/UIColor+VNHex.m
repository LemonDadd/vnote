//
//  UIColor+VNHex.m
//  Voice2Note
//
//  Created by liaojinxing on 14-6-12.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "UIColor+VNHex.h"
#import "Colours.h"

@implementation UIColor (VNHex)

+ (UIColor *) colorWithHex:(NSInteger)rgbHexValue {
  return [UIColor colorWithHex:rgbHexValue alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue
                    alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbHexValue & 0xFF))/255.0
                         alpha:alpha];
}

+ (UIColor *)systemColor
{
    return  [UIColor colorWithHex:0xFFB055];// [UIColor emeraldColor];
}

+ (UIColor *)systemDarkColor
{
    return  [UIColor colorWithHex:0xFFB470];//[UIColor hollyGreenColor];
}

+ (UIColor *)grayBackgroudColor
{
  return [UIColor colorWithHex:0x8C8C8C];
}


@end
