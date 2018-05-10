//
//  UIImageView+LYCoreNetwork.m
//  LYCore
//
//  CREATED BY LUO YU ON 2017-03-01.
//  COPYRIGHT (C) 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "UIImageView+LYCoreNetwork.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFAutoPurgingImageCache.h>
#import <AFNetworking/AFImageDownloader.h>

@implementation UIImageView (LYCoreNetwork)

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName {
	
	// SET PLACEHOLDER IMAGE AT FIRST
	self.image = [UIImage imageNamed:imageName];
	
	if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
		// URL STRING NOT VALID
		return;
	}
	
	NSString *imgIdentifier = [URLString lastPathComponent];
	AFImageDownloader *imgdl = [AFImageDownloader defaultInstance];
	
	UIImage *memCached = [imgdl.imageCache imageforRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] withAdditionalIdentifier:imgIdentifier];
	
	if (!memCached) {
		// NO MEMORY IMAGE CACHE WAS FOUND
		
		// SEARCH FOR HDD IMAGE CACHE
		NSURLCache *imgURLCache = imgdl.sessionManager.session.configuration.URLCache;
		NSCachedURLResponse *cachedResp = [imgURLCache cachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
		
		if (cachedResp.data) {
			// FOUND HDD CACHE
			self.image = [UIImage imageWithData:cachedResp.data];
		} else {
			// NOTHING WAS FOUND
			// REQUEST FROM WEB
			[self setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:imageName]];
		}
		
	} else {
		self.image = memCached;
	}
}

- (void)setImageWithURLString:(NSString *)URLString andPlaceholderNamed:(NSString *)imageName inBundle:(NSBundle *)bundle {
	
	if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
		self.image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
		return;
	}
	
	[self setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil]];
}

@end
