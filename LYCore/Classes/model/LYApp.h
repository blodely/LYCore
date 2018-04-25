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

@interface LYApp : LYModel

+ (instancetype)current;

@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, assign) NSInteger badge;

- (void)updateUserAfterLogin:(NSDictionary *)values;

- (LYUser *)currentUser;

- (void)logout;

@end