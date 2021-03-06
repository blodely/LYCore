//
//  LYCore.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 骆昱(Luo Yu, indie.luo@gmail.com). ALL RIGHTS RESERVED.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
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

#pragma mark LOG

- (NSString *)logError:(NSString *)format, ... {
	va_list args;
	id ret;
	
	va_start(args, format);
	if (format == nil) {
		ret = nil;
	} else {
		format = [format stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
		ret = [[NSString alloc] initWithFormat:format arguments:args];
	}
	
	va_end(args);
	
	if (ret != nil) {
		
		NSLog(@"\n\n❎ERROR :\n\t%@", ret);
		
		return [NSString stringWithFormat:@"\n\n%@\nLYCore ERROR :\n\t%@",
				[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss" andTimezone:[[NSTimeZone defaultTimeZone] name]],
				ret];
	} else {
		// NIL
		NSLog(@"\n\n❎ERROR :\n\t");
	}
	
	return [NSString stringWithFormat:@"\n\n%@\nLYCore ERROR :\n\tNO LOG",
			[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss" andTimezone:[[NSTimeZone defaultTimeZone] name]]];
}

- (NSString *)logWarning:(NSString *)format, ... {
	
	va_list args;
	id ret;
	
	va_start(args, format);
	if (format == nil) {
		ret = nil;
	} else {
		format = [format stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
		ret = [[NSString alloc] initWithFormat:format arguments:args];
	}
	
	va_end(args);
	
	if (ret != nil) {
		
		NSLog(@"\n\n⚠️WARNING :\n\t%@", ret);
		
		return [NSString stringWithFormat:@"\n\n%@\nLYCore WARNING :\n\t%@",
				[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss" andTimezone:[[NSTimeZone defaultTimeZone] name]],
				ret];
	} else {
		// NIL
		NSLog(@"\n\n⚠️WARNING :\n\t");
	}
	
	return [NSString stringWithFormat:@"\n\n%@\nLYCore WARNING :\n\tNO LOG",
			[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss" andTimezone:[[NSTimeZone defaultTimeZone] name]]];
	
}

@end
