# LYCore

General core lib for apps.

### How to use:

Add following code to the top of your project's `Podfile`.

```
source 'https://github.com/blodely/LYSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
```

Then, `pod 'LYCore'`.

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

e.g. 

**LYCoreAPI+Example.h**

```objective-c
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

```objective-c
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

### Author

[骆昱(Luo Yu)](http://luoyu.space)

Email: [indie.luo@gmail.com](mailto:indie.luo@gmail.com)

Date: Tuesday, April 17, 2018