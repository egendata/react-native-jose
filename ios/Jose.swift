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
    func sign(_ message: String, key: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        print("GOT KEY")
        print(key)

        print("GOT message")
        print(message)

        let header = JWSHeader(algorithm: .RS256)

//        let keyData: Data = NSKeyedArchiver.archivedData(withRootObject: keyDictionary)
        let foo = "MIIEogIBAAKCAQEAiADzxMJ+l/NIVPbqz9eoBenUCCUiNNfZ37c6gUJwWEfJRyGchAe96m4GLr3pzj2A3Io4MSKf9dDWMak6qkR/XYljSjZBbXAhQan2sIB5qyPW7NJ7XpJWHoaHdHwEN9Cj29zL+WtFk6lC1rPDmNPRTmRy0ct4EP4YJ49PMcoKJQKbog79ws1KdDzNGTVVkEgLB4VOlW8A164kaK8+xMUxTqySUtigLTDUMqjQ/81SFgsNnMUqnxp87bKD77olYBia88r8V2YXEx1Jgl8t22gNNh6lkN8BDqlkb/Y2uS+c7vlYIfSH6WYkVsSPsrA+GLLRo/R07FGxvs2M5gZxnmlvewIDAQABAoIBADCFCnJdItWpzNnG9zFsEfz+FQ9M1B2/DfLihuQ7ZCIShiuywYhWzLm4Q8tkJGfYCENlqjNZU3Dabrfr1EqPQlMH4xzEK2ZUFQE8lg4U35MfJ5t4Ydv03/Vm8Cct4UFaVULoS/qw+vL5dSdsnXDFzIuniVDwQmbph4uBdHLiTekytlb0N4SFUZWMdYbYNdmJ1JInxOBlU+oCEV9X7rpUL4MPcccpjGqTeMbfrj0Jz/63T7goD3Ti7OXtsfv9TvA8MLde3NS8R0oL8EM7yRFCzpEk5BTGYVBouBNAJwNoJC2yP70dIti419PgzWdkOs7wWj8F63rDfccKm9vWEUFbxRkCgYEAvLn+WftqoWA6EsQ+FfXbHjIhV+1steKgkUXijw6gtt69g6yVMcHpAXLLd13jguC3gDCYrfEM0b80DsisC0p2m7kbH3UIIruUnXxYxNqw+gCix2d0RuiKPQ3vx2VnTZgh7dtF7Sz9TC63dSE+xoNcrhmO5AzIAicVIYGvnJTL4bMCgYEAuHvNn/oSTAWEz2Uf10Dzi6c64aMmlLJy22b6PBK4QG+mTQmR53C1CHq2/73o/ONxtoVl3C+KgmncKwpMjU8We0ohTQEDTKv7uUlmqBpjG1V2NF6G4d1DxLmAhahgAYkKD9NSVzPIO+yLurMPw63Zphcl6umnwfh/OhlMi1gZhxkCgYB7aMhZQN12Tz1KXkcXByDUuwUwwRGwUlSbCm7fCzquujKE8wrQcbOS/eTs1llakOWNjrmYLKMsWPKKpFBURcoPhFinFllOlQjWfqRxfWvy3w2ShST05UTYLc/YvIdzpwKwzg0Izb2I3peaoTWyi93D/vSATZdQSQw5T9ts8aPsnwKBgBHDKcsrYrObHGxzihtJj6l0koDDGqXagKCLS7CZBNB/b32fXELyYRvN5Oy+tj4TEBHIykPm9+kSlDY4qaI5aSq5uncVj+HD9VqjrJSm5b/t/JGSQF5i1XGNgshbq9K6BRP8/sKSo8bRQaraLrxicsBBHk99678LVASeBvarptmRAoGAUq+xPNmhcd7+vP3BslE5JSv0eA14Eyd39Tg85KvsT+zzLDlaWNO2MuvwjeKrvzjX+maPkwUonYd9/jKpdpphk+t8cF5VRM2MA3mCS80nXZXgssRzIF37dvZgZ6pYIKFNmKo/5VQL0z9hAjjKJAc1zb4PPZ19c7CS5CFqg/gZ9dI="
//        let keyData = key.data(using: .utf8)!
        let keyData = Data(base64Encoded: foo as! String)



        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]
//
        var error: Unmanaged<CFError>?
//        let privateKey = try! SecKeyCreateWithData(privateKeyJSON as CFData, attributes as CFDictionary, &error)

        guard let privateKey = SecKeyCreateWithData(keyData as! CFData, attributes as CFDictionary, &error) else {
            print(error!)
            resolve("hello")
            return

        }

        print(privateKey)
////        else {
//            print(error!)
//            return
//        }

//        let jwk = try! RSAPrivateKey(data: keyData)

//        let jwk = try! JSONDecoder().decode(RSAPrivateKey.self, from: keyData)
////
//        let secKey: SecKey = try! jwk.converted(to: SecKey.self)
//
        let data = message.data(using: .utf8)!
        let payload = Payload(data)

//        let signer = Signer(signingAlgorithm: .RS256, privateKey: privateKey)!
//
//        let jws = try! JWS(header: header, payload: payload, signer: signer)

//        print(jws.compactSerializedString)

        let payloadMessage = String(data: payload.data(), encoding: .utf8)!

        resolve(payloadMessage)
    }

    @objc
    func verify(_ message: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let data = message.data(using: .utf8)!

        let payload = Payload(data)
        let payloadMessage = String(data: payload.data(), encoding: .utf8)!

        resolve(payloadMessage)
    }
}
