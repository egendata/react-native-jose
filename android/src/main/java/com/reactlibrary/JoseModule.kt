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


class JoseModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "Jose"
    }

    @ReactMethod
    fun sign(payload: ReadableMap, keys: ReadableMap, header: ReadableMap, promise: Promise) {
        try {
            val claimsSet = JWTClaimsSet.parse(JSONObject(payload.toHashMap()).toString())
            val jwsHeader = JWSHeader.parse(JSONObject(header.toHashMap()).toString())
            val signedJWT = SignedJWT(jwsHeader, claimsSet)
            val rsaJWK = RSAKey.parse(keys.getMap("jwk")!!.toHashMap().toString())
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
    fun verify(stringArgument: String, numberArgument: Int, promise: Promise) {
        println("verify is called")
        println(stringArgument)
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: $numberArgument stringArgument: $stringArgument")
    }

    @ReactMethod
    fun decode(stringArgument: String, numberArgument: Int, promise: Promise) {
        println("decode is called")
        println(stringArgument)
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: $numberArgument stringArgument: $stringArgument")
    }
}
