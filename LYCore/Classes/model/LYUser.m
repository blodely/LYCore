//
//  LYUser.m
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

#import "LYUser.h"
#import "LYCore.h"
#import <FCFileManager/FCFileManager.h>

@implementation LYUser

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![[other class] isEqual:[self class]])
		return NO;

	return [self isEqualToUser:other];
}

- (BOOL)isEqualToUser:(LYUser *)user {
	if (self == user)
		return YES;
	if (user == nil)
		return NO;
	if (self.mobile != user.mobile && ![self.mobile isEqualToString:user.mobile])
		return NO;
	if (self.name != user.name && ![self.name isEqualToString:user.name])
		return NO;
	if (self.gender != user.gender)
		return NO;
	if (self.avatar != user.avatar && ![self.avatar isEqualToString:user.avatar])
		return NO;
	if (self.userInfo != user.userInfo && ![self.userInfo isEqualToDictionary:user.userInfo])
		return NO;
	return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = [self.mobile hash];
	hash = hash * 31u + [self.name hash];
	hash = hash * 31u + (NSInteger) self.gender;
	hash = hash * 31u + [self.avatar hash];
	hash = hash * 31u + [self.userInfo hash];
	return hash;
}

- (id)copyWithZone:(nullable NSZone *)zone {
	LYUser *copy = (LYUser *) [super copyWithZone:zone];

	if (copy != nil) {
		copy.token = self.token;
		copy.mobile = self.mobile;
		copy.name = self.name;
		copy.gender = self.gender;
		copy.avatar = self.avatar;
		copy.userInfo = self.userInfo;
	}

	return copy;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		self.token = [coder decodeObjectForKey:@"self.token"];
		self.mobile = [coder decodeObjectForKey:@"self.mobile"];
		self.name = [coder decodeObjectForKey:@"self.name"];
		self.gender = (LYUserGender) [coder decodeIntForKey:@"self.gender"];
		self.avatar = [coder decodeObjectForKey:@"self.avatar"];
		self.userInfo = [coder decodeObjectForKey:@"self.userInfo"];
	}

	return self;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
	[description appendFormat:@"self.mobile=%@", self.mobile];
	[description appendFormat:@", self.name=%@", self.name];
	[description appendFormat:@", self.gender=%@", @(self.gender)];
	[description appendFormat:@", self.avatar=%@", self.avatar];
	[description appendFormat:@", self.token=%@", self.token];
	[description appendFormat:@", self.userInfo=%@", self.userInfo];
	[description appendString:@">"];
	return description;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	[coder encodeObject:self.token forKey:@"self.token"];
	[coder encodeObject:self.mobile forKey:@"self.mobile"];
	[coder encodeObject:self.name forKey:@"self.name"];
	[coder encodeInteger:self.gender forKey:@"self.gender"];
	[coder encodeObject:self.avatar forKey:@"self.avatar"];
	[coder encodeObject:self.userInfo forKey:@"self.userInfo"];
}

#pragma mark - METHOD

+ (instancetype)userWithUID:(NSString *)theUID {

	if (theUID == nil || ![theUID isKindOfClass:[NSString class]] || [theUID isEqualToString:@""]) {
		[[LYCore core] logError:@"user UID not correct"];
		return nil;
	}

	NSString *userfolder = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", NSStringFromClass([self class])];

	if (![FCFileManager isDirectoryItemAtPath:userfolder]) {
		[[LYCore core] logError:@"user folder not exist"];

		[FCFileManager createDirectoriesForPath:userfolder];
		return nil;
	}

	NSString *userpath = [userfolder stringByAppendingFormat:@"/%@", theUID];

	if (![FCFileManager isFileItemAtPath:userpath]) {
		[[LYCore core] logError:@"user file not exist"];
		return nil;
	}

	return [NSKeyedUnarchiver unarchiveObjectWithFile:userpath];
}

@end
