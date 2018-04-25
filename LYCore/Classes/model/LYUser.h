//
//  LYUser.h
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import <LYCore/LYModel.h>

typedef NS_ENUM(NSUInteger, LYUserGender) {
	LYUserGenderFemale,
	LYUserGenderMale,
	LYUserGenderNull,
};

@interface LYUser : LYModel

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) LYUserGender gender;

@end
