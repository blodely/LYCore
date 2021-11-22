//
//	LYControlResourceAttribute.m
//  LYCore
//
//  CREATED BY LUO YU ON 2021-11-22.
//  COPYRIGHT (C) 2021 骆昱(Luo Yu, indie.luo@gmail.com). ALL RIGHTS RESERVED.
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

#import "LYControlResourceAttribute.h"


@interface LYControlResourceAttribute () {}
@end

@implementation LYControlResourceAttribute

// MARK: - INIT

// MARK: - OVERRIDE

- (BOOL)isEqual:(id)object {	
	if ([object isKindOfClass:[self class]] == NO) {
		return NO;
	}
	
	__weak LYControlResourceAttribute *craobj = object;
	
	if (_title != nil && craobj.title != nil) {
		if ([_title isEqualToString:craobj.title] == NO) {
			return NO;
		}
		// PASS
	} else {
		return NO;
	}
	
	if (_imageName != nil && craobj.imageName != nil) {
		if ([_imageName isEqualToString:craobj.imageName] == NO) {
			return NO;
		}
		// PASS
	} else {
		return NO;
	}
	
	if (_selectedImageName != nil && craobj.selectedImageName != nil && [_selectedImageName isEmpty] == NO && [craobj.selectedImageName isEmpty] == NO) {
		if ([_selectedImageName isEqualToString:craobj.imageName] == NO) {
			return NO;
		}
		// PASS
	} else {
		return NO;
	}
	
	return YES;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"CRA { %@\n\t%@\n\t%@\n\t%@\n\t%@\n}", _title,
			_imageName, _selectedImageName, _normalTextHexColor, _selectedTextHexColor];
}

@end
