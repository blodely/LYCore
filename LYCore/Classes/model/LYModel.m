//
//  LYModel.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYModel.h"
#import "LYCore.h"
#import "FCFileManager.h"

@interface LYModel ()
@end

@implementation LYModel

#pragma mark - OVERRIDE

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self) {
		self.UID = [coder decodeObjectForKey:@"self.UID"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.UID forKey:@"self.UID"];
}

- (id)copyWithZone:(NSZone *)zone {
	LYModel *copy = (LYModel *)[[[self class] allocWithZone:zone] init];
	
	if (copy != nil) {
		copy.UID = self.UID;
	}
	
	return copy;
}

#pragma mark - PUBLIC METHOD

- (void)persist {
	
	// ASSEMBLE MODEL PATH
	NSString *modeldir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", NSStringFromClass([self class])];
	
	if (![FCFileManager isDirectoryItemAtPath:modeldir]) {
		// DIRECTORY NOT EXIST
		// THEN
		// CREATE
		[FCFileManager createDirectoriesForPath:modeldir];
	}
	
	if (_UID == nil || [_UID isEqualToString:@""]) {
		[[LYCore core] logError:@"MODEL <%@> UID => nil", NSStringFromClass([self class])];
		return;
	}
	
	NSString *modelpath = [modeldir stringByAppendingFormat:@"/%@", _UID];
	
	if ([FCFileManager isFileItemAtPath:modelpath]) {
		// FILE EXIST
		// THEN
		// DELETE
		[FCFileManager removeItemAtPath:modelpath];
	}
	
	// ADD FILE
	BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:modelpath];
	[[LYCore core] logWarning:@"WRITE(%@) %@\n%@", NSStringFromClass([self class]),
	 			result ? @"✅SUCCESS" : @"❎FAILED",
	 			self];
}

+ (instancetype)modelByUID:(NSString *)theUID {
	
	NSString *modeldir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", NSStringFromClass([self class])];
	
	if (![FCFileManager isDirectoryItemAtPath:modeldir]) {
		// DIRECTORY NOT EXIST
		return nil;
	}
	
	if (theUID == nil || [theUID isKindOfClass:[NSString class]] == NO || [theUID isEqualToString:@""]) {
		// UID ERROR
		return nil;
	}
	
	NSString *modelpath = [modeldir stringByAppendingFormat:@"/%@", theUID];
	
	if (![FCFileManager isFileItemAtPath:modelpath]) {
		// FILE NOT EXIST
		return nil;
	}
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:modelpath];
}

@end
