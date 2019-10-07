#import "React/RCTBridgeModule.h"
#import <Foundation/Foundation.h>
#import <JOSESwift/JOSESwift.h>

@interface RCT_EXTERN_MODULE(Jose, NSObject)

RCT_EXTERN_METHOD(greet)

RCT_EXTERN_METHOD(promiseRN: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(promiseSignRN: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

@end
