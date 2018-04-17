//
//  LYCore.m
//  Pods
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYCore.h"
#import <LYCategory/LYCategory.h>
#import <FCFileManager/FCFileManager.h>

NSString *const LIB_LYCORE_BUNDLE_ID = @"org.cocoapods.LYCore";
NSString *const NAME_CONF_LY_CORE = @"space.luoyu.core.conf";

@interface LYCore () {}
@end

@implementation LYCore

// MARK: - INIT

- (instancetype)init {
	if (self = [super init]) {
	}
	return self;
}

+ (instancetype)core {
	static LYCore *sharedLYCore;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYCore = [[LYCore alloc] init];
	});
	return sharedLYCore;
}

- (NSDictionary *)conf {
	
	NSString *confpath;
	
	confpath = [[NSBundle mainBundle] pathForResource:NAME_CONF_LY_CORE ofType:@"plist"];
	
	if (confpath == nil || [confpath isEqualToString:@""] == YES || [FCFileManager isFileItemAtPath:confpath] == NO) {
		
		NSLog(@"LYCore WARNING\n\tAPP CONFIGURATION FILE WAS NOT FOUND.\n\t%@", confpath);
		
		// FALLBACK TO LIB DEFAULT
		confpath = [[NSBundle bundleWithIdentifier:LIB_LYCORE_BUNDLE_ID] pathForResource:NAME_CONF_LY_CORE ofType:@"plist"];
	}
	
	// TRY TO READ APP CONFIGURATION
	NSDictionary *conf = [FCFileManager readFileAtPathAsDictionary:confpath];
	
	if (conf == nil) {
		NSLog(@"LYCore ERROR\n\tCONFIGURATION FILE WAS NEVER FOUND.");
	}
	
	return conf;
}

- (id)valueForConfWithKey:(NSString *)keys {
	
	// IF
	if (keys == nil || [keys isEqualToString:@""] || [keys isKindOfClass:[NSString class]] == NO) {
		return nil;
	}
	
	// GET VALUE
	if ([[self conf][keys][@"conf-value"] length]) {
		return [self conf][keys][@"conf-value"];
	}else{
		NSString *confpath = [[NSBundle bundleWithIdentifier:LIB_LYCORE_BUNDLE_ID] pathForResource:NAME_CONF_LY_CORE ofType:@"plist"];
		NSDictionary *conf = [FCFileManager readFileAtPathAsDictionary:confpath];
		return conf[keys][@"conf-value"];
	}
}

@end
