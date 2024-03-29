//
//	LYLabelControl.m
//	LYCore
//
//	CREATED BY LUO YU ON 2019-05-26.
//	COPYRIGHT (C) 2019 骆昱(Luo Yu, indie.luo@gmail.com). ALL RIGHTS RESERVED.
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

#import "LYLabelControl.h"
#import <LYCategory/LYCategory.h>
#import <LYCore/LYCore.h>
#import <Masonry/Masonry.h>


// MARK: - LYBlockMenuItem

@interface LYBlockMenuItem : UIMenuItem
- (instancetype)initWithTitle:(NSString *)title action:(void (^)(void))action;
@end

@interface LYBlockMenuItem () {
	LYCCompletion blockAction;
}
@end

@implementation LYBlockMenuItem

- (void)itemActionTriggered:(id)sender {
	if (blockAction != nil) {
		blockAction();
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
}

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(void))action {
	if (self = [super initWithTitle:title action:@selector(itemActionTriggered:)]) {
		blockAction = action;
	}
	return self;
}

@end

// MARK: - LYLabelControl

@implementation LYLabelControl
@end

// MARK: - LYCalloutCopyLabel

@interface LYCalloutCopyLabel () {
	NSString *copyTitle;
	LYCCompletion blockCopy;
}
@end

@implementation LYCalloutCopyLabel

- (void)longPressed:(id)sender {
	[self becomeFirstResponder];
	
	UIMenuController *menuctl = [UIMenuController sharedMenuController];
	menuctl.menuItems = @[[[UIMenuItem alloc] initWithTitle:copyTitle action:@selector(menuItemCopyTapped:)],];
	[menuctl setTargetRect:self.bounds inView:self];
	[menuctl setMenuVisible:YES animated:YES];
}

- (void)initial {
	[super initial];
	
	{
		self.userInteractionEnabled = YES;
		self.clipsToBounds = NO;
		UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
		[self addGestureRecognizer:gesture];
	}
	
	{
		// MARK: LABEL
		UILabel *view = [[UILabel alloc] init];
		[self addSubview:view];
		_label = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(menuItemCopyTapped:)) {
		return YES;
	}
	return NO;
}

- (void)menuItemCopyTapped:(id)sender {
	if (sender == nil) {
		return;
	}
	
	if (blockCopy != nil) {
		blockCopy();
	}
}

- (void)setCopyTitle:(NSString *)title {
	if (title == nil || [title isKindOfClass:[NSString class]] == NO || [title isEqualToString:@""]) {
		copyTitle = @"Copy";
		return;
	}
	
	copyTitle = title;
}

- (void)calloutAction:(void (^)(void))action {
	blockCopy = action;
}

@end
