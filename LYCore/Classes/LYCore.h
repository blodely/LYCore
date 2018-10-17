//
//  LYCore.h
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


#import <Foundation/Foundation.h>
#import <LYCore/LYCore.h>
#import <LYCore/LYCoreAPI.h>
#import <LYCore/LYModel.h>
#import <LYCore/LYApp.h>
#import <LYCore/LYUser.h>
#import <LYCategory/LYCategory.h>
#import <LYCore/UIImageView+LYCoreNetwork.h>
#import <LYCore/UIColor+LYCore.h>
#import <LYCore/LYWebViewController.h>
#import <LYCore/UINavigationController+LYCore.h>
#import <LYCore/UIViewController+LYCore.h>


//! Project version number for LYCore.
FOUNDATION_EXPORT double LYCoreVersionNumber;

//! Project version string for LYCore.
FOUNDATION_EXPORT const unsigned char LYCoreVersionString[];

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
