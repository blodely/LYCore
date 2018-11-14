# LYCore

General core lib for apps.

### How to use:

Simply add`pod 'LYCore'`, then run 'pod install'.

#### configure networking env

make a copy of `space.luoyu.core.conf.plist` configuration template, and add it to your project.

Key|Value example<br>(_change to your own server settings_)|Remark
---|:---|---
core-net-domain|app.luoyu.space|Core Networking Domain(Production)
core-net-domain-dev|dev.luoyu.space|Core Networking Domain(Development)
core-net-api-path|/api|Core Networking API path(Production)
core-net-api-path-dev|/api-v2|Core Networking API path(Development)
core-net-is-secure-transport|https://|Transport Security Toggle(Production)
core-net-is-secure-transport-dev|http://|Transport Security Toggle(Development)

by toggling `[LYCore core].debug` _(BOOL)_, lib will use corresponding values to generate session manager.

example:

```bash
# production mode
https://app.luoyu.space/api

# development mode
http://dev.luoyu.space/api-v2
```

##### * You can add your own key-value configurations

and access it by...

```objective-c
// get configuration data (NSDictionary object)
[[LYCore core] conf];
```

or

```objective-c
// get value for key
[[LYCore core] valueForConfWithKey:@"the-key-name"];
```

### Custom request

Simply add category to LYCoreAPI, then you can write your own specified request method.

example:

**LYCoreAPI+Example.h**

```objc
#import <LYCore/LYCore.h>

@interface LYCoreAPI (Example)

- (NSURLSessionDataTask *)GETURLString:(NSString *)URLString
	withParameters:(NSDictionary *)params
	success:(void (^)(id ret))success
	error:(void (^)(NSInteger code, NSString *msg, id ret))apierror
	failure:(void (^)(NSError *error))failure;

@end
```

this add an api error block for project error code handling.

**LYCoreAPI+Example.m**

```objc
#import "LYCoreAPI+Example.h"

@implementation LYCoreAPI (Example)
- (NSURLSessionDataTask *)GETURLString:(NSString *)URLString withParameters:(NSDictionary *)params success:(void (^)(id))success error:(void (^)(NSInteger, NSString *, id))apierror failure:(void (^)(NSError *))failure {
    NSURLSessionDataTask *datatask = [self GETURLString:URLString withParameters:params success:^(id ret) {
        if (ret == nil) {
            apierror(1, @"NULL RESPONSE", ret);
        } else {
            success(ret);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return datatask;
}
@end
```

### Locating

Core lib now can use CoreLocation to get current placemark, start with 1.0.31.

usage:

```objc
[[LYApp current] updateLocation:^(CLLocationCoordinate2D coordinate, CLPlacemark *place) {
	// IF 'place' IS NOT NIL,
	// MEANS SUCCESSFULLY GET CURRENT LOCATION PLACEMARK.
	NSLog("%@", place);
}];
```

### Author

[骆昱(Luo Yu)](http://luoyu.space)

Email: [indie.luo@gmail.com](mailto:indie.luo@gmail.com)

Date: Tuesday, April 17, 2018
