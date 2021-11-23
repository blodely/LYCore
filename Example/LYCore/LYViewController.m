//
//  LYViewController.m
//  LYCore_Example
//
//  CREATED BY LUO YU ON 2018-03-01.
//  COPYRIGHT (C) 2018 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYViewController.h"
#import <LYCore/LYCore.h>
#import <FCFileManager/FCFileManager.h>
#import <LYCore/LYLabelControl.h>
#import <Masonry/Masonry.h>


@interface LYViewController () {
	
	__weak LYCalloutCopyLabel *lblCallout;
	
	__weak IBOutlet LYGradientControl *cGradient;
}

@end

@implementation LYViewController

// MARK: - ACTION

- (IBAction)showWebViewButtonPressed:(id)sender {
}

- (IBAction)showLocationOfHere:(id)sender {
	
	[[LYApp current] askPermissionOfLocating:^{
		[[LYApp current] updateLocation:^(CLLocationCoordinate2D coordinate, CLPlacemark *place) {
			NSLog(@"\n\nLatitude: %@\nLongitude: %@\nPLACEMARK: %@",
				  @(coordinate.latitude),
				  @(coordinate.longitude),
				  place);
		}];
	} from:self];
}

- (IBAction)showATestWebView:(id)sender {
	
}

// MARK: - INIT

- (instancetype)init {
	if (self = [super initWithNibName:@"LYViewController" bundle:[NSBundle mainBundle]]) {
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	{
		// DEMO APP
		self.navigationItem.title = @"LYCore Demo";
		
		for (id view in [self.view subviews]) {
			if ([view isKindOfClass:[UIButton class]]) {
				[view border1Px];
			}
		}
	}
	
	{
		// MARK: NAV BAR VIEW DEMO
		LYNavbarView *view = [LYNavbarView navbar];
		view.lblTitle.text = @"LYCore Demo";
		view.btnBack.hidden = NO;
		[self.view addSubview:view];
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.top.equalTo(self.view);
		}];
		
		// FOR TEST PURPOSE SHOW VIEW'S BORDER
		[view border1Px];
		[view.btnBack border1Px];
	}
	
	{
		LYCalloutCopyLabel *view = [LYCalloutCopyLabel view];
		[self.view addSubview:view];
		lblCallout = view;
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(300);
			make.left.equalTo(self.view).offset(16);
			make.right.equalTo(self.view).offset(-16);
			make.height.mas_equalTo(30);
		}];
		
		[lblCallout border1Px];
		lblCallout.label.font = [UIFont systemFontOfSize:14];
		lblCallout.label.textColor = [UIColor blueColor];
		lblCallout.label.text = @"long press callout";
		
		[lblCallout setCopyTitle:@"C o p y"];
		[lblCallout calloutAction:^{
			NSLog(@"copy action");
		}];
	}
	
	{
		cGradient.colors = @[
			[UIColor redColor],
			[UIColor blueColor],
		];
		cGradient.locations = @[@0, @1,];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW FROM ITS NIB.
	
	NSLog(@"CoreNetDomain: %@", [[LYCore core] valueForConfWithKey:@"core-net-domain"]);
	
	[[LYCoreAPI core] GETURLString:@"/post" withParameters:nil success:^(id ret) {
		
	} failure:^(NSError *error) {
		
	}];
	
	[[LYCore core] logError:@"HELLO ERROR"];
	[[LYCore core] logWarning:@"Hello, warnings"];
	
	LYModel *modeltest = [[LYModel alloc] init];
	modeltest.UID = @"lalala";
	[modeltest persist];
	
	LYModel *one = [LYModel modelByUID:@"lalala"];
	NSLog(@"MODEL TEST %@", one);
	
	[[LYCoreAPI core] networkingReachability:^(AFNetworkReachabilityStatus status) {
		NSLog(@"called - networking changed");
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// DISPOSE OF ANY RESOURCES THAT CAN BE RECREATED.
}


@end
