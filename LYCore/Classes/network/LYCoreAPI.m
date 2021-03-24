//
//  LYCoreAPI.m
//  AFNetworking
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

+ (instancetype)core:(BOOL)debugMode {
	static LYCoreAPI *sharedLYCoreAPI;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYCoreAPI = [[LYCoreAPI alloc] initWithDebugMode:debugMode];
	});
	return sharedLYCoreAPI;
}

+ (instancetype)core {
	// DEBUG MODE PARAMETER WILL BE IGNORED
	return [self core:NO];
}

- (instancetype)initWithDebugMode:(BOOL)debugMode {
	if (self = [super init]) {
		
		_debug = debugMode;
		
		if (_debug) {
			// DEBUG VERSION
			PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport-dev"];
			BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain-dev"];
			API = [[LYCore core] valueForConfWithKey:@"core-net-api-path-dev"];
		} else {
			if ([LYCore core].debug) {
				// PRE-PRODUCTION
				PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport-pre"];
				BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain-pre"];
				API = [[LYCore core] valueForConfWithKey:@"core-net-api-path-pre"];
			} else {
				// PRODUCTION VERSION
				PROTOCOL = [[LYCore core] valueForConfWithKey:@"core-net-is-secure-transport"];
				BASE_URL = [[LYCore core] valueForConfWithKey:@"core-net-domain"];
				API = [[LYCore core] valueForConfWithKey:@"core-net-api-path"];
			}
		}
		
		[self initialManager];
	}
	return self;
}

- (void)initialManager {
	if (manager == nil) {
		manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithFormat:@"%@%@", PROTOCOL, BASE_URL]];
	}
	
	if (absolute == nil) {
		absolute = [[AFHTTPSessionManager alloc] init];
	}
	
	// SETUP JSON FORMAT
	AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
	NSMutableSet *types = [responseSerializer.acceptableContentTypes mutableCopy];
	((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = [[[LYCore core] valueForConfWithKey:@"core-net-json-null"] boolValue];

	[types addObject:@"json/text"]; // OR OTHERS
	[types addObject:@"text/plain"];
	[types addObject:@"text/html"];
	[types addObject:@"application/json"];
	
	responseSerializer.acceptableContentTypes = types;
	manager.responseSerializer = responseSerializer;
	
	if ([[[LYCore core] valueForConfWithKey:@"core-net-force-absolute-json"] boolValue]) {
		absolute.responseSerializer = responseSerializer;
	}
	
	AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
	[requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	[requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
	// "Accept-Language" = "zh-Hans-CN;q=1";
	// "User-Agent" = "AppUATemplate/1.0.0 (iPhone; iOS 10.1; Scale/2.00)";
	manager.requestSerializer = requestSerializer;
	
	// SET TIMEOUT
	manager.requestSerializer.timeoutInterval = [[[LYCore core] valueForConfWithKey:@"core-net-timeout"] doubleValue];
	absolute.requestSerializer.timeoutInterval = [[[LYCore core] valueForConfWithKey:@"core-net-timeout"] doubleValue];
}

- (void)networkingReachability:(void (^)(AFNetworkReachabilityStatus status))statusChangeBlock {
	
	AFNetworkReachabilityManager *nmgr = [AFNetworkReachabilityManager sharedManager];
	
	[nmgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		switch (status) {
			case AFNetworkReachabilityStatusUnknown: {
				NSLog(@"\nLYCoreAPI\n\tReachability\n\tUnknown Networking Status\n");
			}
				break;
			case AFNetworkReachabilityStatusNotReachable: {
				NSLog(@"\nLYCoreAPI\n\tReachability\n\tNot Reachable\n");
			}
				break;
			case AFNetworkReachabilityStatusReachableViaWiFi: {
				NSLog(@"\nLYCoreAPI\n\tReachability\n\tWiFi\n");
			}
				break;
			case AFNetworkReachabilityStatusReachableViaWWAN: {
				NSLog(@"\nLYCoreAPI\n\tReachability\n\tMobile\n");
			}
				break;
			default: {
				NSLog(@"\nLYCoreAPI\n\tReachability\n\tDefault\n");
			}
				break;
		}
		statusChangeBlock(status);
	}];
	
	[nmgr startMonitoring];
}

// MARK: - REQUEST

- (NSURLSessionDataTask *)GETURLString:(NSString *)URLString
						withParameters:(NSDictionary *)params
							   success:(void (^)(id))success
							   failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *dataTask = [manager GET:[API stringByAppendingString:URLString] parameters:params headers:nil progress:^(NSProgress *downloadProgress) {
		// PROGRESS
	} success:^(NSURLSessionDataTask *task, id resp) {
		
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(GET) ✅SUCCESS\n\tAPI\t%@\n", URLString);
		
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
	
	NSURLSessionDataTask *dataTask = [manager POST:[API stringByAppendingString:URLString] parameters:params headers:nil progress:^(NSProgress *uploadProgress) {
		
	} success:^(NSURLSessionDataTask *task, id resp) {
		
		// SUCCESS
		success(resp);
		NSLog(@"\n\nREQUEST(POST) ✅SUCCESS\n\tAPI\t%@\n", URLString);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		// REQUEST FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(POST) FAILED\n\tAPI\t%@\n", URLString);
	}];
	
	return dataTask;
	
}

- (NSURLSessionDataTask *)GETAbsoluteURLString:(NSString *)URLString withParameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *datatask = [absolute GET:URLString parameters:params headers:nil progress:^(NSProgress *downloadProgress) {

	} success:^(NSURLSessionDataTask *task, id resp) {
		
		// SUCCESS
		success(resp);
		// NSLog(@"\n\nREQUEST(GET) ✅SUCCESS\n\tABSOLUTE\t%@\n", URLString);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		
		// FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(GET) ❎FAILED\n\tABSOLUTE\t%@\n", URLString);
	}];
	
	return datatask;
}

- (NSURLSessionDataTask *)POSTAbsoluteURLString:(NSString *)URLString withParameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *datatask = [absolute POST:URLString parameters:params headers:nil progress:^(NSProgress *uploadProgress) {
		
	} success:^(NSURLSessionDataTask *task, id resp) {
		// SUCCESS
		success(resp);
		// NSLog(@"\n\nREQUEST(POST) ✅SUCCESS\n\tABSOLUTE\t%@\n", URLString);
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		// FAILED
		failure(error);
		NSLog(@"\n\nREQUEST(POST) ❎FAILED\n\tABSOLUTE\t%@\n", URLString);
	}];
	
	return datatask;
}

- (NSURLSessionDataTask *)POSTFormURLString:(NSString *)URLString binary:(id)data
								 parameters:(NSDictionary *)param
									   name:(NSString *)name
								   filename:(NSString *)filename
								   mimeType:(NSString *)mimetype
								   progress:(void (^)(float percent))progress
									success:(void (^)(id ret))success
									failure:(void (^)(NSError *))failure {
	
	NSURLSessionDataTask *datatask = [absolute POST:URLString parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		
		[formData appendPartWithFileData:data name:name fileName:filename mimeType:mimetype];
		
	} progress:^(NSProgress *uploadProgress) {
		progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
	} success:^(NSURLSessionDataTask *task, id responseObject) {
		success(responseObject);
		NSLog(@"\n\nREQUEST(POST-FORMDATA) ✅SUCCESS\n\tABSOLUTE\t%@\n\n", URLString);
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		failure(error);
		NSLog(@"\n\nREQUEST(POST-FORMDATA) ❎FAILED\n\tURL\t%@\n\n", URLString);
	}];
	
	return datatask;
}

- (void)GETImageURLString:(NSString *)URLString success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure {
	
	if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || [URLString isEqualToString:@""]) {
		// URL STRING NOT VALID
		failure(nil);
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
