//
//  LYUser.h
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
#import <LYCore/LYModel.h>

typedef NS_ENUM(NSInteger, LYUserGender) {
	LYUserGenderFemale = 0,
	LYUserGenderMale = 1,
	LYUserGenderNull = -1,
};

@interface LYUser : LYModel

/// login token string
@property (nonatomic, copy) NSString *token;

/// user mobile number string
@property (nonatomic, copy) NSString *mobile;

/// user name
@property (nonatomic, copy) NSString *name;

/// user gender
@property (nonatomic, assign) LYUserGender gender;

/// user avatar url
@property (nonatomic, copy) NSString *avatar;

/// extra info dictionary
@property (nonatomic, copy) NSDictionary *userInfo;

/// create an user instance by UID
/// @param theUID UID string
+ (instancetype)userWithUID:(NSString *)theUID;

/// compare to user object, check if it's the same user.
/// @param user user instance
- (BOOL)isEqualToUser:(LYUser *)user;

@end
