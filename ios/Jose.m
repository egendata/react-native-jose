#import "React/RCTBridgeModule.h"
#import <Foundation/Foundation.h>
#import <JOSESwift.h>

@interface RCT_EXTERN_MODULE(Jose, NSObject)

RCT_EXTERN_METHOD(sign: (NSDictionary *)payload
                  key: (NSString)key
                  header: (NSDictionary *)header
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verify: (NSString)token
                  jwk: (NSDictionary *)jwk
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

@end
