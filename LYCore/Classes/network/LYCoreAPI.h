//
//  LYCoreAPI.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface LYCoreAPI : NSObject

/**
 toggle debug mode
 */
@property (nonatomic, assign) BOOL debug;

/**
 get core api singleton

 @return instance
 */
+ (instancetype)core;

/**
 monitoring networking reachability
 */
- (void)networkingReachability:(void (^)(AFNetworkReachabilityStatus status))statusChangeBlock;

/**
 make GET request

 @param URLString api url string
 @param params parameters
 @param success request success block
 @param failure request failure block
 @return session task
 */
- (NSURLSessionDataTask *)GETURLString:(NSString *)URLString
						withParameters:(NSDictionary *)params
							   success:(void (^)(id ret))success
							   failure:(void (^)(NSError *error))failure;

/**
 make POST request

 @param URLString api url string
 @param params parameters
 @param success request success block
 @param failure request failure block
 @return session task
 */
- (NSURLSessionDataTask *)POSTURLString:(NSString *)URLString
						 withParameters:(NSDictionary *)params
								success:(void (^)(id ret))success
								failure:(void (^)(NSError *error))failure;

/**
 make GET request using absolute url

 @param URLString url
 @param params parameters
 @param success request success block
 @param failure request failure block
 @return session data task
 */
- (NSURLSessionDataTask *)GETAbsoluteURLString:(NSString *)URLString
								withParameters:(NSDictionary *)params
									   success:(void (^)(id ret))success
									   failure:(void (^)(NSError *error))failure;

/**
 make POST request using absolute url

 @param URLString url
 @param params parameters
 @param success success block
 @param failure failure block
 @return session data task
 */
- (NSURLSessionDataTask *)POSTAbsoluteURLString:(NSString *)URLString
								 withParameters:(NSDictionary *)params
										success:(void (^)(id ret))success
										failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)POSTFormURLString:(NSString *)URLString binary:(id)data
								 parameters:(NSDictionary *)param
									   name:(NSString *)name
								   filename:(NSString *)filename
								   mimeType:(NSString *)mimetype
								   progress:(void (^)(float percent))progress
									success:(void (^)(id ret))success
									failure:(void (^)(NSError *))failure;

- (void)GETImageURLString:(NSString *)URLString
				  success:(void (^)(UIImage *image))success
				  failure:(void (^)(NSError *error))failure;

@end
