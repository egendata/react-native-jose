//
//  Jose.swift
//  Jose
//
//  Created by Radu Achim on 2019-10-02.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

/*
 When you want to build this project standalone uncomment the import JOSESwift
 */

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

    @objc
    func promiseSignRN(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let message = "Trumpets of Mexico 🏜"

        let data = message.data(using: .utf8)!

        let payload = Payload(data)
        let payloadMessage = String(data: payload.data(), encoding: .utf8)!

        resolve(payloadMessage)
    }

    @objc
    func sign(_ message: String, key: String, jwk: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        print("GOT message")
        print(message)

        print("GOT KEY")
        print(key)

        print("GOT jwk")
        print(jwk)

        let jwkDictionary = try! jwk as? [String: Any]

        let headerData = try! JSONSerialization.data(withJSONObject: ["jwk":jwkDictionary, "alg":SignatureAlgorithm.RS256.rawValue], options: [])
        let header = JWSHeader(headerData)!

        let keyData = Data(base64Encoded: key as! String)

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        var error: Unmanaged<CFError>?

        guard let privateKey = SecKeyCreateWithData(keyData as! CFData, attributes as CFDictionary, &error) else {
            print(error!)
            reject("500", "it b0rked", error as? Error)
            return

        }

        let data = message.data(using: .utf8)!
        let payload = Payload(data)

        let signer = Signer(signingAlgorithm: .RS256, privateKey: privateKey)!
        let jws = try! JWS(header: header, payload: payload, signer: signer)

        resolve(jws.compactSerializedString)
    }

    @objc
    func verify(_ message: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let data = message.data(using: .utf8)!

        let payload = Payload(data)
        let payloadMessage = String(data: payload.data(), encoding: .utf8)!

        resolve(payloadMessage)
    }
}
