package com.reactlibrary

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

class JoseModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "Jose"
    }

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
            promise.resolve(signedJWT.payload.toJSONObject())
        } catch (ex: Exception) {
            promise.reject(ex)
        }
    }

    @ReactMethod
    fun decode(stringArgument: String, numberArgument: Int, promise: Promise) {
        println("decode is called")
        println(stringArgument)
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: $numberArgument stringArgument: $stringArgument")
    }
}
