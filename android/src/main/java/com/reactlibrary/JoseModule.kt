package com.reactlibrary

import android.util.Base64
import com.facebook.react.bridge.*
import com.nimbusds.jose.JWSHeader
import com.nimbusds.jose.crypto.RSASSASigner
import com.nimbusds.jose.crypto.bc.BouncyCastleProviderSingleton
import com.nimbusds.jose.jwk.RSAKey
import com.nimbusds.jwt.JWTClaimsSet
import com.nimbusds.jwt.SignedJWT
import com.facebook.react.bridge.ReadableMap
import org.json.JSONObject
import com.nimbusds.jose.crypto.RSASSAVerifier
import com.facebook.react.bridge.WritableNativeMap
import com.nimbusds.jose.crypto.impl.RSA_OAEP
import com.reactlibrary.Utils.convertJsonToMap


class JoseModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "Jose"

    @ReactMethod
    fun sign(payload: ReadableMap, keys: ReadableMap, header: ReadableMap, promise: Promise) {
        try {
            val payloadString = JSONObject(payload.toHashMap()).toString()
            val headerString = JSONObject(header.toHashMap()).toString()
            val jwkString = JSONObject(keys.getMap("jwk")!!.toHashMap()).toString()

            val claimsSet = JWTClaimsSet.parse(payloadString)
            val jwsHeader = JWSHeader.parse(headerString)
            val signedJWT = SignedJWT(jwsHeader, claimsSet)
            val rsaJWK = RSAKey.parse(jwkString)
            val signer = RSASSASigner(rsaJWK)
            signer.jcaContext.provider = BouncyCastleProviderSingleton.getInstance()
            signedJWT.sign(signer)
            val jwt = signedJWT.serialize()
            promise.resolve(jwt)
        } catch (ex: Exception) {
            promise.reject(ex)
        }
    }

    @ReactMethod
    fun verify(token: String, jwk: ReadableMap, promise: Promise) {
        try {
            val signedJWT = SignedJWT.parse(token)
            val jwkString = JSONObject(jwk.toHashMap()).toString()
            val rsaJWK = RSAKey.parse(jwkString)
            val verifier = RSASSAVerifier(rsaJWK)
            verifier.jcaContext.provider = BouncyCastleProviderSingleton.getInstance()
            signedJWT.verify(verifier)
            val result = convertJsonToMap(JSONObject(signedJWT.payload.toJSONObject()))
            promise.resolve(result)
        } catch (ex: Exception) {
            promise.reject(ex)
        }
    }

    @ReactMethod
    fun decode(token: String, options: ReadableMap, promise: Promise) {
        try {
            val signedJWT = SignedJWT.parse(token)
            val claimsSet = convertJsonToMap(JSONObject(signedJWT.payload.toJSONObject()))
            val signature = signedJWT.signature
            val header = convertJsonToMap(JSONObject(signedJWT.header.toJSONObject()))
            val result = WritableNativeMap().apply {
                putMap("claimsSet", claimsSet)
                putMap("header", header)
                putString("signature", signature.toString())
            }
            promise.resolve(result)
        } catch (ex: Exception) {
            promise.reject(ex)
        }
    }

    @ReactMethod
    fun reEncryptCek(encryptedCek: String, ownerKeys: ReadableMap, recipientKeys: ReadableMap, alg: String, promise: Promise) {
        try {
            val ownerJwkString = JSONObject(ownerKeys.getMap("jwk")!!.toHashMap()).toString()
            val ownerKey = RSAKey.parse(ownerJwkString)
            val recipientJwkString = JSONObject(recipientKeys.getMap("jwk")!!.toHashMap()).toString()
            val recipientKey = RSAKey.parse(recipientJwkString)
            val base64flags = Base64.URL_SAFE + Base64.NO_PADDING + Base64.NO_WRAP
            val decryptedData = RSA_OAEP.decryptCEK(ownerKey.toRSAPrivateKey(), Base64.decode(encryptedCek, base64flags), BouncyCastleProviderSingleton.getInstance())
            val encryptedData = RSA_OAEP.encryptCEK(recipientKey.toRSAPublicKey(), decryptedData, BouncyCastleProviderSingleton.getInstance())
            promise.resolve(Base64.encodeToString(encryptedData, base64flags))
        } catch (ex: Exception) {
            promise.reject(ex)
        }
    }
}
