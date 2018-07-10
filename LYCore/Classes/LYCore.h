//
//  LYCore.h
//  Pods
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import <LYCore/LYCore.h>
#import <LYCore/LYCoreAPI.h>
#import <LYCore/LYModel.h>
#import <LYCore/LYApp.h>
#import <LYCore/LYUser.h>
#import <LYCategory/LYCategory.h>
#import <LYCore/UIImageView+LYCoreNetwork.h>
#import <LYCore/UIColor+LYCore.h>


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

- (NSString *)logError:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (NSString *)logWarning:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end
