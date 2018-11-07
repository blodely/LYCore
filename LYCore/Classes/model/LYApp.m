//
//  LYApp.m
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

#import "LYApp.h"
#import <FCFileManager/FCFileManager.h>

NSString *const NOTIF_USER_UPDATED = @"notif.ly.app.user.updated";
NSString *const NOTIF_USER_LOGOUT = @"notif.ly.app.user.logout";

@interface LYApp () {
}
@end

@implementation LYApp

@synthesize isLoggedIn = _isLoggedIn;
@synthesize badge = _badge;

#pragma mark - INIT

+ (instancetype)current {
	static LYApp *sharedLYApp;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYApp = [[LYApp alloc] init];
	});
	return sharedLYApp;
}

- (instancetype)init {
	if (self = [super init]) {
		
		self.UID = @"default.appdata.dimo"; // THIS INSTANCE SHOULD BE A SINGLETON
		
		_isLoggedIn = NO;
		_userID = nil;
		_target = nil;
		_lastLoginName = nil;
		_badge = 0;

		[self synchronize];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		self.isLoggedIn = [coder decodeBoolForKey:@"self.isLoggedIn"];
		self.userID = [coder decodeObjectForKey:@"self.userID"];
		self.badge = [coder decodeIntegerForKey:@"self.badge"];
		self.target = [coder decodeObjectForKey:@"self.target"];
		self.lastLoginName = [coder decodeObjectForKey:@"self.last.login.name"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	LYApp *app = (LYApp *)[super copyWithZone:zone];
	
	if (app != nil) {
		app.isLoggedIn = self.isLoggedIn;
		app.userID = self.userID;
		app.badge = self.badge;
		app.target = self.target;
		app.lastLoginName = self.lastLoginName;
	}
	
	return app;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeBool:self.isLoggedIn forKey:@"self.isLoggedIn"];
	[coder encodeObject:self.userID forKey:@"self.userID"];
	[coder encodeInteger:self.badge forKey:@"self.badge"];
	[coder encodeObject:self.target forKey:@"self.target"];
	[coder encodeObject:self.lastLoginName forKey:@"self.last.login.name"];
}

#pragma mark - PROPERTIES

#pragma mark - METHOD

- (void)updateUserAfterLogin:(NSDictionary *)values {
	// DONE: PERSIST USER

	if (values == nil || [values isKindOfClass:[NSDictionary class]] == NO || [[values allKeys] count] == 0) {
		[[LYCore core] logError:@"WRITE USER DATA: EMPTY RECEIVED"];
		return;
	}

	_isLoggedIn = YES;
	_userID = values[@"userID"];
	_lastLoginName = values[@"lastLoginName"];

	LYUser *user = [[LYUser alloc] init];
	user.UID = _userID;
	user.token = values[@"token"];
	user.mobile = values[@"mobile"];
	user.name = values[@"name"];
	user.gender = [values[@"gender"] integerValue] == 1 ? LYUserGenderMale : LYUserGenderFemale;
	user.avatar = values[@"avatar"];
	user.userInfo = values[@"userInfo"];

	[user persist];
	
	// POST USER INFO UPDATED NOTIFICATION
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_UPDATED object:nil];

	[self persist];
}

- (LYUser *)currentUser {
	// DONE: CURRENT LOGGED-IN USER GETTER
	return [LYUser userWithUID:[LYApp current].userID];
}

- (void)logout {
	// DONE: CLEAN EVERYTHING

	_userID = nil;
	_isLoggedIn = NO;

	[self persist];

	// LOGOUT NOTIFICATION
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_LOGOUT object:nil userInfo:nil];
}

- (void)updateTargetDate:(NSDate *)targetDate {
	
	if ([targetDate isKindOfClass:[NSDate class]] == NO) {
		return;
	}
	
	_target = targetDate;
	
	[self persist];
}

#pragma mark PRIVATE METHOD

- (void)synchronize {
	
	NSString *appfolder = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/LYApp"];
	
	if (![FCFileManager isDirectoryItemAtPath:appfolder]) {
		// NOT EXIST
		// THEN
		// CREATE
		return;
	}
	
	NSString *apppath = [appfolder stringByAppendingFormat:@"/%@", self.UID];
	
	if (![FCFileManager isFileItemAtPath:apppath]) {
		// NOT EXIST
		// THEN CREATE AND WRITE
		return;
	}
	
	// HAVE FILE
	// THEN
	// READ
	LYApp *app = (LYApp *)[NSKeyedUnarchiver unarchiveObjectWithFile:apppath];
	// [FCFileManager readFileAtPathAsData:apppath];
	
	_isLoggedIn = app.isLoggedIn;
	_userID = app.userID;
	_target = app.target;
	_badge = app.badge;
	_lastLoginName = app.lastLoginName;
	
	app = nil;
}

// MARK: OVERRIDE

- (NSString *)description {
	return [NSString stringWithFormat:@"\n\nLYApp : \n\tisLoggedIn = %@\n\tuserID = %@\n\ttarget = %@\n\tbadge = %@\n\tlastLoginName = %@\n\tURL (%@/Documents/LYApp/%@)",
			_isLoggedIn ? @"YES" : @"NO",
			_userID,
			[_target stringWithFormat:@"yyyy-MM-dd hh:mm:ss" andTimezone:TZShanghai],
			@(_badge),
			_lastLoginName,
			NSHomeDirectory(), self.UID];
}

@end
