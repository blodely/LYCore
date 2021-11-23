//
//  LYGradientControl.m
//	LYCore
//
//	CREATED BY LUO YU ON 2021-11-23.
//	COPYRIGHT (C) 2021 骆昱(Luo Yu, indie.luo@gmail.com). ALL RIGHTS RESERVED.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
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

#import "LYGradientControl.h"


@implementation LYGradientControl

// MARK: - INIT

- (void)initial {
	[super initial];
	
	{
		_colors = @[
			[UIColor clearColor],
			[UIColor clearColor],
		];
	}
	
	{
		_locations = @[@0, @1,];
	}
	
	{
		_startPoint = (CGPoint){0, 0.5};
		_endPoint = (CGPoint){1, 0.5};
	}
}

// MARK: - METHOD

// MARK: PRIVATE METHOD

- (void)resetGradient {
	__weak CAGradientLayer *layer = (CAGradientLayer *)[self layer];
	layer.locations = _locations;
	
	{
		NSMutableArray *mcolors = [NSMutableArray arrayWithCapacity:1];
		for (UIColor *color in _colors) {
			[mcolors addObject:( (__bridge id)color.CGColor )];
		}
		layer.colors = [NSArray arrayWithArray:mcolors];
	}
	
	layer.startPoint = _startPoint;
	layer.endPoint = _endPoint;
}

// MARK: PROPERTY

- (void)setColors:(NSArray<UIColor *> *)colors {
	if (colors == nil || [colors isKindOfClass:[NSArray class]] == NO ||
		colors.count == 0 ||
		[colors.firstObject isKindOfClass:[UIColor class]] == NO) {
		
		_colors = @[
			[UIColor clearColor],
			[UIColor clearColor],
		];
	} else {
		_colors = colors;
	}
	
	[self resetGradient];
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
	if (locations == nil ||
		[locations isKindOfClass:[NSArray class]] ||
		locations.count == 0 ||
		[locations.firstObject isKindOfClass:[NSNumber class]] == NO) {
		_locations = @[@0, @1];
	} else {
		_locations = locations;
	}
	
	[self resetGradient];
}

- (void)setStartPoint:(CGPoint)startPoint {
	_startPoint = startPoint;
	
	[self resetGradient];
}

- (void)setEndPoint:(CGPoint)endPoint {
	_endPoint = endPoint;
	
	[self resetGradient];
}

// MARK: OVERWRITE

+ (Class)layerClass {
	return [CAGradientLayer class];
}

@end
