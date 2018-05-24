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

@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, assign) NSInteger badge;

@property (nonatomic, strong) NSDate *target;

@property (nonatomic, strong) NSString *lastLoginName;

- (void)updateUserAfterLogin:(NSDictionary *)values;

- (LYUser *)currentUser;

- (void)logout;

- (void)updateTargetDate:(NSDate *)targetDate;

@end
