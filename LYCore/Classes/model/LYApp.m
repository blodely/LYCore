//
//  LYApp.m
//  LYCore
//
//  CREATED BY LUO YU ON 2018-04-28.
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

#import "LYApp.h"
#import <FCFileManager/FCFileManager.h>
#import <CoreLocation/CoreLocation.h>


NSString *const NOTIF_USER_UPDATED = @"notif.ly.app.user.updated";
NSString *const NOTIF_USER_LOGOUT = @"notif.ly.app.user.logout";

typedef void(^LYAppLocationUpdatedBlock)(CLLocationCoordinate2D coordinate, CLPlacemark *place);

@interface LYApp () <CLLocationManagerDelegate> {
	LYAppLocationUpdatedBlock updatedBlock;
	CLLocationManager *locmgr;
}
@end

@implementation LYApp

@synthesize isLoggedIn = _isLoggedIn;
@synthesize badge = _badge;

#pragma mark - INIT

+ (instancetype)current {
	static LYApp *sharedLYApp;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYApp = [[LYApp alloc] init];
	});
	return sharedLYApp;
}

- (instancetype)init {
	if (self = [super init]) {
		
		self.UID = @"default.appdata.dimo"; // THIS INSTANCE SHOULD BE A SINGLETON
		
		_isLoggedIn = NO;
		_userID = nil;
		_target = nil;
		_lastLoginName = nil;
		_badge = 0;

		[self synchronize];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		self.isLoggedIn = [coder decodeBoolForKey:@"self.isLoggedIn"];
		self.userID = [coder decodeObjectForKey:@"self.userID"];
		self.badge = [coder decodeIntegerForKey:@"self.badge"];
		self.target = [coder decodeObjectForKey:@"self.target"];
		self.lastLoginName = [coder decodeObjectForKey:@"self.last.login.name"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	LYApp *app = (LYApp *)[super copyWithZone:zone];
	
	if (app != nil) {
		app.isLoggedIn = self.isLoggedIn;
		app.userID = self.userID;
		app.badge = self.badge;
		app.target = self.target;
		app.lastLoginName = self.lastLoginName;
	}
	
	return app;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeBool:self.isLoggedIn forKey:@"self.isLoggedIn"];
	[coder encodeObject:self.userID forKey:@"self.userID"];
	[coder encodeInteger:self.badge forKey:@"self.badge"];
	[coder encodeObject:self.target forKey:@"self.target"];
	[coder encodeObject:self.lastLoginName forKey:@"self.last.login.name"];
}

#pragma mark - PROPERTIES

#pragma mark - METHOD

- (void)updateUserAfterLogin:(NSDictionary *)values {
	// DONE: PERSIST USER

	if (values == nil || [values isKindOfClass:[NSDictionary class]] == NO || [[values allKeys] count] == 0) {
		[[LYCore core] logError:@"WRITE USER DATA: EMPTY RECEIVED"];
		return;
	}

	_isLoggedIn = YES;
	_userID = values[@"userID"];
	_lastLoginName = values[@"lastLoginName"];

	LYUser *user = [[LYUser alloc] init];
	user.UID = _userID;
	user.token = values[@"token"];
	user.mobile = values[@"mobile"];
	user.name = values[@"name"];
	user.gender = [values[@"gender"] integerValue] == 1 ? LYUserGenderMale : LYUserGenderFemale;
	user.avatar = values[@"avatar"];
	user.userInfo = values[@"userInfo"];

	[user persist];
	
	// POST USER INFO UPDATED NOTIFICATION
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_UPDATED object:nil];

	[self persist];
}

- (LYUser *)currentUser {
	// DONE: CURRENT LOGGED-IN USER GETTER
	return [LYUser userWithUID:[LYApp current].userID];
}

- (void)logout {
	// DONE: CLEAN EVERYTHING

	_userID = nil;
	_isLoggedIn = NO;

	[self persist];

	// LOGOUT NOTIFICATION
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_LOGOUT object:nil userInfo:nil];
}

- (void)updateTargetDate:(NSDate *)targetDate {
	
	if ([targetDate isKindOfClass:[NSDate class]] == NO) {
		return;
	}
	
	_target = targetDate;
	
	[self persist];
}

- (void)askPermissionOfLocating:(void (^)(void))action from:(UIViewController *)viewctl {
	
	if (locmgr == nil) {
		locmgr = [[CLLocationManager alloc] init];
		locmgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
	
	locmgr.delegate = self;
	
	switch ([CLLocationManager authorizationStatus]) {
		case kCLAuthorizationStatusNotDetermined: {
			// FIRST OPEN APP
			// ASK FOR PERMISSION
			[locmgr requestWhenInUseAuthorization];
		} break;
		case kCLAuthorizationStatusAuthorizedAlways:
			// ALREADY AUTH 'ALWAYS'
			action();
		case kCLAuthorizationStatusAuthorizedWhenInUse: {
			// ALREADY AUTH 'WHEN IN USE'
			// PASS
			action();
		} break;
		case kCLAuthorizationStatusRestricted:
			// RESTRICTED
		case kCLAuthorizationStatusDenied: {
			// DENIED
			
			NSString *title = [[LYCore core] valueForConfWithKey:@"core-location-denied-title"];
			NSString *message = [[LYCore core] valueForConfWithKey:@"core-location-denied-message"];
			NSString *cancel = [[LYCore core] valueForConfWithKey:@"core-location-denied-cancel"];
			NSString *confirm = [[LYCore core] valueForConfWithKey:@"core-location-denied-settings"];
			
			[UIAlertController showAlertFromView:(viewctl != nil ? viewctl : [UIApplication sharedApplication].keyWindow.rootViewController)
			withTitle:(title == nil ? @"We need your location permission." : title)
			andMessage:(message == nil ? @"Change permission in Settings" : message)
			cancelButtonTitle:(cancel == nil ? @"Got it" : cancel)
			confirmButtonTitle:(confirm == nil ? @"Settings" : confirm)
			confirmAction:^{
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}];
		} break;
		default:
			break;
	}
	
	
}

- (void)updateLocation:(void (^)(CLLocationCoordinate2D, CLPlacemark *))action {
	
	if (action != nil) {
		updatedBlock = action;
	}
	
	if (locmgr == nil) {
		locmgr = [[CLLocationManager alloc] init];
		locmgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
	
	locmgr.delegate = self;
	
	if ([CLLocationManager locationServicesEnabled]) {
		[locmgr startUpdatingLocation];
		
		[LYCore core].debug ? NSLog(@"\n\nLYApp BEGIN UPDATING LOCATION\n") : 0;
	} else {
		[LYCore core].debug ? NSLog(@"\n\nLYApp CANNOT UPDATE LOCATION\nDUE TO SERVICE DISABLED\n") : 0;
	}
	
}

#pragma mark PRIVATE METHOD

- (void)synchronize {
	
	NSString *appfolder = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/LYApp"];
	
	if (![FCFileManager isDirectoryItemAtPath:appfolder]) {
		// NOT EXIST
		// THEN
		// CREATE
		return;
	}
	
	NSString *apppath = [appfolder stringByAppendingFormat:@"/%@", self.UID];
	
	if (![FCFileManager isFileItemAtPath:apppath]) {
		// NOT EXIST
		// THEN CREATE AND WRITE
		return;
	}
	
	// HAVE FILE
	// THEN
	// READ
	LYApp *app = (LYApp *)[NSKeyedUnarchiver unarchiveObjectWithFile:apppath];
	// [FCFileManager readFileAtPathAsData:apppath];
	
	_isLoggedIn = app.isLoggedIn;
	_userID = app.userID;
	_target = app.target;
	_badge = app.badge;
	_lastLoginName = app.lastLoginName;
	
	app = nil;
}

// MARK: OVERRIDE

- (NSString *)description {
	return [NSString stringWithFormat:@"\n\nLYApp : \n\tisLoggedIn = %@\n\tuserID = %@\n\ttarget = %@\n\tbadge = %@\n\tlastLoginName = %@\n\tURL (%@/Documents/LYApp/%@)",
			_isLoggedIn ? @"YES" : @"NO",
			_userID,
			[_target stringWithFormat:@"yyyy-MM-dd hh:mm:ss" andTimezone:TZShanghai],
			@(_badge),
			_lastLoginName,
			NSHomeDirectory(), self.UID];
}

// MARK: - DELEGATE

// MARK: CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	
	[manager stopUpdatingLocation];
	[[LYCore core] logWarning:@"STOP LOCATING"];
	
	CLGeocoder *geocdr = [[CLGeocoder alloc] init];
	if (@available(iOS 11.0, *)) {
		[geocdr reverseGeocodeLocation:locations.firstObject preferredLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			
			if (self->updatedBlock == nil) {
				[[LYCore core] logWarning:@"BLOCK NOT FOUND"];
				return;
			}
			
			if (error) {
				self->updatedBlock(kCLLocationCoordinate2DInvalid, nil);
				[[LYCore core] logError:@"LOCATING ERROR"];
				return;
			}
			
			CLPlacemark *place = placemarks.firstObject;
			self->updatedBlock(place.location.coordinate, place);
		}];
	} else {
		// FALLBACK ON EARLIER VERSIONS
		[geocdr reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			
			if (self->updatedBlock == nil) {
				[[LYCore core] logWarning:@"BLOCK NOT FOUND"];
				return;
			}
			
			if (error) {
				self->updatedBlock(kCLLocationCoordinate2DInvalid, nil);
				[[LYCore core] logError:@"LOCATING ERROR"];
				return;
			}
			
			CLPlacemark *place = placemarks.firstObject;
			self->updatedBlock(place.location.coordinate, place);
		}];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	[[LYCore core] logError:@"LOCATING FAILED"];
	
	[manager stopUpdatingLocation];
	[[LYCore core] logWarning:@"STOP LOCATING"];
	
	if (updatedBlock == nil) {
		[[LYCore core] logWarning:@"BLOCK NOT FOUND"];
	} else {
		updatedBlock(kCLLocationCoordinate2DInvalid, nil);
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	[[LYCore core] logWarning:@"LOCATION MANAGER AUTH STATUS %@", @(status)];
}

@end
