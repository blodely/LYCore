//
//  LYCore.h
//  Pods
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString *const LIB_LYCORE_BUNDLE_ID;

@interface LYCore : NSObject

/**
 toggle debug mode
 */
@property (nonatomic, assign) BOOL debug;

/**
 Core lib singleton

 @return instance
 */
+ (instancetype)core;


/**
 core lib configurations

 @return configuration data
 */
- (NSDictionary *)conf;

/**
 get value for key configuration data

 @param keys key name
 @return configuration value
 */
- (id)valueForConfWithKey:(NSString *)keys;

@end
