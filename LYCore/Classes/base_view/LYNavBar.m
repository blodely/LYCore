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
#import <Masonry/Masonry.h>


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
	//self.clipsToBounds = YES;
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

// MARK: - LYNavbarView

@interface LYNavbarView () {
	__strong LYCCompletion actionBack;
}
@end

@implementation LYNavbarView

// MARK: - ACTION

- (void)navBackButtonPressed:(id)sender {
	if (actionBack != nil) {
		actionBack();
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
}

// MARK: - INIT

- (instancetype)init {
	if (self = [super initWithFrame:(CGRect){0, 0, WIDTH, 44 + SAFE_TOP}]) {
		[self initial];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	frame.origin = CGPointZero;
	frame.size.width = WIDTH;
	frame.size.height = 44 + SAFE_TOP;
	if (self = [super initWithFrame:frame]) {
		[self initial];
	}
	return self;
}

- (void)initial {
	self.backgroundColor = [UIColor whiteColor];
	
	{
		// MARK: NAV BACK BUTTON
		UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:view];
		_btnBack = view;
		
		[_btnBack addTarget:self action:@selector(navBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.bottom.equalTo(self);
			make.width.height.mas_equalTo(44);
		}];
	}
	
	{
		// MARK: NAV TITLE LABEL
		UILabel *view = [[UILabel alloc] init];
		view.font = [UIFont boldSystemFontOfSize:16];
		view.textAlignment = NSTextAlignmentCenter;
		[self addSubview:view];
		_lblTitle = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self->_btnBack.mas_trailing);
			make.right.equalTo(self).offset(-44);
			make.bottom.equalTo(self);
			if (@available(iOS 11.0, *)) {
				make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
			} else {
				make.top.equalTo(self).offset(SAFE_TOP);
			}
			make.height.equalTo(self->_btnBack);
		}];
	}
}

+ (instancetype)navbar {
	return [[[self class] alloc] initWithFrame:CGRectZero];
}

// MARK: - METHOD

- (void)navBackAction:(void (^)(void))action {
	actionBack = action;
}

// MARK: OVERRIDE

- (void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	
	_lblTitle.textColor = tintColor;
}

@end
