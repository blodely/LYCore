//
//  LYCoreAPI.m
//  AFNetworking
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYCoreAPI.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFAutoPurgingImageCache.h>
#import <AFNetworking/AFImageDownloader.h>
#import "LYCore.h"
#import <LYCategory/LYCategory.h>

@interface LYCoreAPI () {
	AFHTTPSessionManager *manager;
	AFHTTPSessionManager *absolute;
	
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
	absolute = [[AFHTTPSessionManager alloc] init];
	
	// SETUP JSON FORMAT
	AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
	NSMutableSet *types = [responseSerializer.acceptableContentTypes mutableCopy];
	((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

	[types addObject:@"json/text"]; // OR OTHERS
	[types addObject:@"text/plain"];
	[types addObject:@"text/html"];
	[types addObject:@"application/json"];
	
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

// MARK: - REQUEST

- (NSURLSessionDataTask *)GETURLString:(NSString *)URLString
						withParameters:(NSDictionary *)params
							   success:(void (^)(id))success
							   failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *dataTask = [manager GET:[API stringByAppendingString:URLString] parameters:params progress:^(NSProgress *downloadProgress) {
		// PROGRESS
	} success:^(NSURLSessionDataTask *task, id resp) {
		
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(GET) SUCCESS\n\tAPI\t%@\n", URLString);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		// REQUEST FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(GET) FAILED\n\tAPI\t%@\n", URLString);
	}];
	
	return dataTask;
}

- (NSURLSessionDataTask *)POSTURLString:(NSString *)URLString
						 withParameters:(NSDictionary *)params
								success:(void (^)(id))success
								failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *dataTask = [manager POST:[API stringByAppendingString:URLString] parameters:params progress:^(NSProgress *uploadProgress) {
		
	} success:^(NSURLSessionDataTask *task, id resp) {
		
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(POST) SUCCESS\n\tAPI\t%@\n", URLString);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		// REQUEST FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(POST) FAILED\n\tAPI\t%@\n", URLString);
	}];
	
	return dataTask;
	
}

- (NSURLSessionDataTask *)GETAbsoluteURLString:(NSString *)URLString withParameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *datatask = [absolute GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resp) {
		
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(GET) SUCCESS\n\tABSOLUTE\t%@\n", URLString);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		// FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(GET) FAILED\n\tABSOLUTE\t%@\n", URLString);
	}];
	
	return datatask;
}

- (NSURLSessionDataTask *)POSTAbsoluteURLString:(NSString *)URLString withParameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *datatask = [absolute POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resp) {
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(POST) SUCCESS\n\tABSOLUTE\t%@\n", URLString);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		// FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(POST) FAILED\n\tABSOLUTE\t%@\n", URLString);
	}];
	
	return datatask;
}

- (void)GETImageURLString:(NSString *)URLString success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure {
	
	if (URLString == nil || [URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
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
			success([UIImage imageWithData:cachedResp.data]);
		} else {
			// NOTHING WAS FOUND
			// REQUEST FROM WEB
			// TODO:
			NSURLRequest *request = [NSURLRequest requestWithFormat:@"%@", URLString];
			[imgdl downloadImageForURLRequest:request withReceiptID:[NSUUID UUID] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
				success(responseObject);
			} failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
				failure(error);
			}];
		}
		
	} else {
		success(memCached);
	}
}

@end
