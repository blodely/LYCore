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
		self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
}

// MARK: VIEW LIFE CYCLE

- (void)loadView {
	[super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW.
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

@end
