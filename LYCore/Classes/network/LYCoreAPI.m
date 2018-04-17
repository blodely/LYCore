//
//  LYCoreAPI.m
//  AFNetworking
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYCoreAPI.h"
#import <AFNetworking/AFNetworking.h>
#import "LYCore.h"


@interface LYCoreAPI () {
	AFHTTPSessionManager *manager;
	
	NSString *PROTOCOL;
	NSString *BASE_URL;
	NSString *API;
}
@end

@implementation LYCoreAPI

// MARK: - INIT

+ (instancetype)core {
	static LYCoreAPI *sharedLYCoreAPI;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYCoreAPI = [[LYCoreAPI alloc] init];
	});
	return sharedLYCoreAPI;
}

- (instancetype)init {
	if (self = [super init]) {
		
		_debug = NO;
		
		if (_debug) {
			// DEBUG VERSION
			PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport-dev"];
			BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain-dev"];
			API = [[LYCore core] valueForConfWithKey:@"core-net-api-path-dev"];
		} else {
			// PRODUCTION VERSION
			PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport"];
			BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain"];
			API = [[LYCore core] valueForConfWithKey:@"core-net-api-path"];
		}
		
		[self initialManager];
	}
	return self;
}

- (void)initialManager {
	manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithFormat:@"%@%@", PROTOCOL, BASE_URL]];
	
	// SETUP JSON FORMAT
	AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
	NSMutableSet *types = [responseSerializer.acceptableContentTypes mutableCopy];
	((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
	[types addObject:@"json/text"]; // OR OTHERS
	[types addObject:@"text/plain"];
	[types addObject:@"text/html"];
	responseSerializer.acceptableContentTypes = types;
	manager.responseSerializer = responseSerializer;
	
	AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
	[requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	[requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
	// "Accept-Language" = "zh-Hans-CN;q=1";
	// "User-Agent" = "AppUATemplate/1.0.0 (iPhone; iOS 10.1; Scale/2.00)";
	manager.requestSerializer = requestSerializer;
}

- (void)setDebug:(BOOL)debug {
	_debug = debug;
	
	if (_debug) {
		// DEBUG VERSION
		PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport-dev"];
		BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain-dev"];
		API = [[LYCore core] valueForConfWithKey:@"core-net-api-path-dev"];
	} else {
		// PRODUCTION VERSION
		PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport"];
		BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain"];
		API = [[LYCore core] valueForConfWithKey:@"core-net-api-path"];
	}
	
	[self initialManager];
}

@end
