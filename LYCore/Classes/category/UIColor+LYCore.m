//
//  UIColor+LYCore.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-06-05.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "UIColor+LYCore.h"
#import <LYCategory/UIColor+Speed.h>
#import "LYCore.h"

@implementation UIColor (LYCore)

+ (UIColor *)coreThemeColor {
	return [UIColor colorWithHex:[[LYCore core] valueForConfWithKey:@"core-theme-color"] andAlpha:1.0];
}

@end
