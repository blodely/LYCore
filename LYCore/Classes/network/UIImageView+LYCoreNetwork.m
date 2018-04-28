//
//  UIImageView+LYCoreNetwork.m
//  LYCore
//
//  CREATED BY LUO YU ON 2017-03-01.
//  COPYRIGHT (C) 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "UIImageView+LYCoreNetwork.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@implementation UIImageView (LYCoreNetwork)

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName {
	
	if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
		self.image = [UIImage imageNamed:imageName];
		return;
	}
	
	[self setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:imageName]];
}

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName inBundle:(NSBundle *)bundle {
	
	if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
		self.image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
		return;
	}
	
	[self setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil]];
}

@end
