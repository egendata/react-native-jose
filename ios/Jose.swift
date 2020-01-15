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
    func sign(_ payload: NSDictionary, keys: NSDictionary, header: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let headerData = try! JSONSerialization.data(withJSONObject: try! header as? [String: Any], options: [])
        let jwsHeader = JWSHeader(headerData)!
        let keyData = Data(base64Encoded: keys["der"] as! String)
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
        let payloadDictionary = try! payload as? [String: Any]
        let payloadData = try! JSONSerialization.data(withJSONObject: payloadDictionary, options: [])
        let payload = Payload(payloadData)
        let signer = Signer(signingAlgorithm: jwsHeader.algorithm!, privateKey: privateKey)!
        let jws = try! JWS(header: jwsHeader, payload: payload, signer: signer)

        resolve(jws.compactSerializedString)
    }

    @objc
    func verify(_ token: String, jwk: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let jws = try! JWS(compactSerialization: token)
        let publicKeyJson = try! JSONSerialization.data(withJSONObject: try! jwk as? [String: Any], options: [])
        let jwkDecoded = try! JSONDecoder().decode(RSAPublicKey.self, from: publicKeyJson)
        let publicKey: SecKey = try! jwkDecoded.converted(to: SecKey.self)
        let verifier = Verifier(verifyingAlgorithm: jws.header.algorithm!, publicKey: publicKey)!
        let payload = try! jws.validate(using: verifier).payload
        let jsonPayload = try! JSONSerialization.jsonObject(with: payload.data(), options: [])

        resolve(jsonPayload)
    }

    @objc
    func decode(_ token: String, options: NSDictionary, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        let jws = try! JOSEDeserializer().deserialize(JWS.self, fromCompactSerialization: token)
        let jsonPayload = try! JSONSerialization.jsonObject(with: jws.payload.data(), options: [])
        let signature = [UInt8](jws.signature)
        resolve(["claimsSet": jsonPayload, "header": jws.header.parameters, "signature": signature])
    }

    @objc
    func reEncryptCek(_ encryptedCek: String, ownerKeys: NSDictionary, recipientKeys: NSDictionary, alg: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        var error: Unmanaged<CFError>?
        let ownerKeyAttributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]
        let recipientKeyAttributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048
        ]
        let ownerKeyData = Data(base64Encoded: ownerKeys["der"] as! String)
        let recipientKeyData = Data(base64Encoded: recipientKeys["der"] as! String)
        guard let ownerKey = SecKeyCreateWithData(ownerKeyData as! CFData, ownerKeyAttributes as CFDictionary, &error) else {
            print(error!)
            reject("500", "create owner key failed", error as? Error)
            return
        }
        guard let recipientKey = SecKeyCreateWithData(recipientKeyData as! CFData, recipientKeyAttributes as CFDictionary, &error) else {
            print(error!)
            reject("500", "create recipient key failed", error as? Error)
            return
        }

        let decryptedData = try! RSA.decrypt(Data(base64URLEncoded: encryptedCek)!, with: ownerKey, and: .RSAOAEP)
        let encryptedCek = try! RSA.encrypt(decryptedData, with: recipientKey, and: .RSAOAEP)
        resolve(encryptedCek.base64URLEncodedString())
    }
}
