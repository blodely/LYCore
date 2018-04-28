//
//  UIImageView+LYCoreNetwork.h
//  LYCore
//
//  CREATED BY LUO YU ON 2017-03-01.
//  COPYRIGHT (C) 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LYCoreNetwork)

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName;

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName inBundle:(NSBundle *)bundle;

@end
