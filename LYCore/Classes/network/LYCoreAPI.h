//
//  LYCoreAPI.h
//  AFNetworking
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>

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


@end
