//
//  LYModel.h
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>

@interface LYModel : NSObject <NSCoding, NSCopying>

/**
 Unique ID.
 */
@property (nonatomic, strong) NSString *UID;

/**
 Persist Model.
 */
- (void)persist;

+ (instancetype)modelByUID:(NSString *)theUID;

@end
