//
//  LYNavBar.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-11-02.
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

#import "LYNavBar.h"
#import <LYCategory/LYCategory.h>


@interface LYNavBar () {}
@end

@implementation LYNavBar

// MARK: - INIT

- (instancetype)init {
	if (self = [super initWithFrame:(CGRect){0, 0, WIDTH, 44}]) {
		[self initial];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	frame.origin = CGPointZero;
	frame.size.width = WIDTH;
	frame.size.height = 44;
	if (self = [super initWithFrame:frame]) {
		[self initial];
	}
	return self;
}

- (void)initial {
	// SET DEFAULT BG COLOR
	self.clipsToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];
}

+ (instancetype)navbar {
	return [[[self class] alloc] initWithFrame:CGRectZero];
}

// MARK: - METHOD

// MARK: PRIVATE METHOD

// MARK: OVERRIDE

- (void)setFrame:(CGRect)frame {
	frame.origin = CGPointZero;
	frame.size.width = WIDTH;
	frame.size.height = 44;
	[super setFrame:frame];
}

@end
