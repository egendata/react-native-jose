#import "React/RCTBridgeModule.h"
#import <Foundation/Foundation.h>
#import <JOSESwift.h>

@interface RCT_EXTERN_MODULE(Jose, NSObject)

RCT_EXTERN_METHOD(greet)

RCT_EXTERN_METHOD(promiseRN: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(promiseSignRN: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sign: (NSString)message
                  key: (NSString)key
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verify: (NSString)message
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

@end
