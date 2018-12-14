//
//  LYWebViewController.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-09-13.
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

#import "LYWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import <LYCategory/LYCategory.h>
#import "UIColor+LYCore.h"

@interface LYWebViewController () {
	
}
@end

@implementation LYWebViewController

// MARK: - ACTION

// MARK: - INIT

- (instancetype)init {
	if (self = [super init]) {
		[self initial];
	}
	return self;
}

- (void)initial {
	
	{
		self.view.backgroundColor = [UIColor whiteColor];
	}
	
	{
		WKWebViewConfiguration *wconf = [[WKWebViewConfiguration alloc] init];
		WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wconf];
		[self.view addSubview:webview];
		web = webview;

		[webview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
		}];
	}
	
	{
		UIProgressView *progressview = [[UIProgressView alloc] initWithFrame:CGRectZero];
		[self.view addSubview:progressview];
		progress = progressview;
		
		progress.tintColor = [UIColor coreThemeColor];
		progress.backgroundColor = [UIColor clearColor];
		[self.view bringSubviewToFront:progress];
		
		[progressview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self.view).offset(0);
			make.top.equalTo(self.view).offset(0);
		}];
	}
	
	{
		// LISTEN WEB VIEW EVENT
		[web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
	}
}

// MARK: VIEW LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
	// DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW.
	
	if (self.navigationController != nil) {
		self.navigationItem.title = self.title != nil ? self.title : @"";
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:_navbarHidden animated:animated];
}

- (void)dealloc {
	
	[web removeObserver:self forKeyPath:@"estimatedProgress"];
}

// MARK: - METHOD

// MARK: PRIVATE METHOD

// MARK: NETWORKING

// MARK: - PROPERTY

- (void)setURLString:(NSString *)URLString {
	_URLString = URLString;
	
	[web loadRequest:[NSURLRequest requestWithFormat:@"%@", _URLString]];
}

// MARK: - DELEGATE

// MARK:

// MARK: - NOTIFICATION

// MARK:

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"estimatedProgress"] && object == web) {
		progress.alpha = 1.0f;
		[progress setProgress:web.estimatedProgress animated:YES];
		
		if (web.estimatedProgress >= 1.0f) {
			// DELAY ONE SECOND TO DISMISS PROGRESS BAR
			[UIView animateWithDuration:ANIMATE delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self->progress.alpha = 0;
			} completion:^(BOOL finished) {
				self->progress.progress = 0.0f;
			}];
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
