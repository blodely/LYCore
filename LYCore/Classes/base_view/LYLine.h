//
//  LYLine.h
//  LYCore
//
//  CREATED BY LUO YU ON 2018-10-31.
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

//#import <LYCore/LYCore.h>
#import <LYCore/LYView.h>

/**
 View for seperator line: set clips to bound, with user interaction disabled.
 */
@interface LYLine : LYView

/**
 create a line view with specified hex color string background color.

 @param hexColor hex color string
 @return an instance of LYLine view
 */
+ (instancetype)lineWithHexColor:(NSString *)hexColor;

/**
 create a line view instance with specified color as background color.

 @param backgroundColor color
 @return an instance of LYLine view
 */
+ (instancetype)lineWithColor:(UIColor *)backgroundColor;

@end

