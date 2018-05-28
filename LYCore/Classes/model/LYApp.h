//
//  LYApp.h
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
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
