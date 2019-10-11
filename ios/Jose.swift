//
//  Jose.swift
//  Jose
//
//  Created by Radu Achim on 2019-10-02.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
//import JOSESwift

@objc(Jose)
class Jose: NSObject {

   /*
    To suppress this warning, you simply have to implement the specified method, and return a Boolean:
    true if you need this class initialized on the main thread
    false if the class can be initialized on a background thread 
   */
    @objc
    static func requiresMainQueueSetup() -> Bool {
      return true
    }

    @objc
    func greet() {
        print("called greet")
    }

    @objc
    func promiseRN(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        resolve("#### Resolve done")
    }
    
//    @objc
//    func promiseSignRN(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
//        let message = "Trumpets of Mexico 🏜"
//
//        let data = message.data(using: .utf8)!
//
//        let payload = Payload(data)
//
//        resolve(payload)
//    }
}
