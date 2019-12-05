#import "React/RCTBridgeModule.h"
#import <Foundation/Foundation.h>
#import <JOSESwift.h>

@interface RCT_EXTERN_MODULE(Jose, NSObject)

RCT_EXTERN_METHOD(sign: (NSDictionary *)payload
                  keys: (NSDictionary *)keys
                  header: (NSDictionary *)header
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verify: (NSString)token
                  jwk: (NSDictionary *)jwk
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(reEncryptCek: (NSString)encryptedCek
                  ownerKeys: (NSDictionary *)ownerKeys
                  recipientKeys: (NSDictionary *)recipientKeys
                  alg: (NSString)alg
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

@end
