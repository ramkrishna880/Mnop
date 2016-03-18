//
//  UIColor+Helpers.m
//  Lapanzo
//
//  Created by PTG on 15/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *)colorFromRGBforRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green {
    return [self colorWithRed:(float)red/255.0 green:(float)blue/255.0 blue:(float)green/255.0 alpha:1.0];
}

+ (UIColor *)progressGreenColor {
    return [self colorFromRGBforRed:0 blue:199 green:71];
}

@end
