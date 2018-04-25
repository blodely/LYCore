//
//  LYApp.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYApp.h"

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
		
		self.UID = @"default.app"; // THIS INSTANCE SHOULD BE A SINGLETON
		
		_isLoggedIn = NO;
		_userID = nil;
		_badge = 0;
		
		self syn
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		self.isLoggedIn = [coder decodeBoolForKey:@"self.isLoggedIn"];
		self.userID = [coder decodeObjectForKey:@"self.userID"];
		self.badge = [coder decodeIntegerForKey:@"self.badge"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	LYApp *app = (LYApp *)[super copyWithZone:zone];
	
	if (app != nil) {
		app.isLoggedIn = self.isLoggedIn;
		app.userID = self.userID;
		app.badge = self.badge;
	}
	
	return app;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeBool:self.isLoggedIn forKey:@"self.isLoggedIn"];
	[coder encodeObject:self.userID forKey:@"self.userID"];
	[coder encodeInteger:self.badge forKey:@"self.badge"];
}

#pragma mark - PROPERTIES

- (BOOL)isLoggedIn {
	return NO;
}

- (void)setIsLoggedIn:(BOOL)isLoggedIn {
	// TODO: WRITE TO USER DEFAULTS
}

#pragma mark - METHOD

- (void)updateUserAfterLogin:(NSDictionary *)values {
	// TODO: PERSIST USER
}

- (LYUser *)currentUser {
	// TODO: CURRENT LOGGED-IN USER GETTER
	return nil;
}

- (void)logout {
	// TODO: CLEAN EVERYTHING
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
	_badge = app.badge;
	
	app = nil;
}

@end
