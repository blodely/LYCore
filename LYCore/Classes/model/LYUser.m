//
//  LYUser.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYUser.h"

@implementation LYUser

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		self.mobile = [coder decodeObjectForKey:@"self.mobile"];
		self.name = [coder decodeObjectForKey:@"self.name"];
		self.gender = (LYUserGender) [coder decodeIntForKey:@"self.gender"];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	[coder encodeObject:self.mobile forKey:@"self.mobile"];
	[coder encodeObject:self.name forKey:@"self.name"];
	[coder encodeInt:self.gender forKey:@"self.gender"];
}

- (id)copyWithZone:(nullable NSZone *)zone {
	LYUser *copy = (LYUser *) [super copyWithZone:zone];

	if (copy != nil) {
		copy.mobile = self.mobile;
		copy.name = self.name;
		copy.gender = self.gender;
	}

	return copy;
}

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
	return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = [self.mobile hash];
	hash = hash * 31u + [self.name hash];
	hash = hash * 31u + (NSUInteger) self.gender;
	return hash;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
	[description appendFormat:@"self.mobile=%@", self.mobile];
	[description appendFormat:@", self.name=%@", self.name];
	[description appendFormat:@", self.gender=%d", self.gender];
	[description appendString:@">"];
	return description;
}


@end
