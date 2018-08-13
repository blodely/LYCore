//
//  LYModel.m
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

#import "LYModel.h"
#import "LYCore.h"
#import <FCFileManager/FCFileManager.h>

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

- (NSString *)description {
	return [NSString stringWithFormat:@"\n\n%@\n\t%@\n\tUID\t%@",
				NSStringFromClass([self class]),
				[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@/%@", NSStringFromClass([self class]), _UID],
				_UID
			];
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
