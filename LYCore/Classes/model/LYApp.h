//
//  LYApp.h
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
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
#import <LYCore/LYModel.h>

@class LYUser;

FOUNDATION_EXPORT NSString *const NOTIF_USER_UPDATED;
FOUNDATION_EXPORT NSString *const NOTIF_USER_LOGOUT;

@interface LYApp : LYModel

+ (instancetype)current;

/**
 is user logged in
 */
@property (nonatomic, assign) BOOL isLoggedIn;

/**
 user ID
 */
@property (nonatomic, strong) NSString *userID;

/**
 app badge number
 */
@property (nonatomic, assign) NSInteger badge;

/**
 target date
 */
@property (nonatomic, strong) NSDate *target;

/**
 last successfully login user name
 */
@property (nonatomic, strong) NSString *lastLoginName;

/**
 update current user after login action

 @param values userInfo
 */
- (void)updateUserAfterLogin:(NSDictionary *)values;

/**
 get current user instance

 @return instance of the current logged in user
 */
- (LYUser *)currentUser;

/**
 logout method
 */
- (void)logout;

/**
 set a target date

 @param targetDate target date
 */
- (void)updateTargetDate:(NSDate *)targetDate;

@end
