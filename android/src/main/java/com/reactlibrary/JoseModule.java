package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jose.crypto.bc.BouncyCastleProviderSingleton;
import com.nimbusds.jose.jwk.JWK;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import net.minidev.json.JSONObject;


public class JoseModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public JoseModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Jose";
    }

    @ReactMethod
    public void sign(ReadableMap payload, String key, ReadableMap header, Promise promise) {
        System.out.println("sign is called");
        System.out.println(payload);
        System.out.println(payload.toString());
        System.out.println(key);
        System.out.println(header);
        try {
            JWTClaimsSet claimsSet = JWTClaimsSet.parse("{\"exp\":1574070011,\"iat\":1574066411,\"pds\":{\"access_token\":\"nope\",\"provider\":\"memory\"},\"iss\":\"egendata://account/27c1060e-f228-4c89-8d19-17e7ec2ea8f6\",\"aud\":\"https://operator-test.dev.services.jtech.se/api\",\"type\":\"ACCOUNT_REGISTRATION\"}");
            JWSHeader jwsHeader = JWSHeader.parse("{\"alg\":\"PS256\",\"jwk\":{\"use\":\"sig\",\"n\":\"t9XwN7EWca0kl7qAnweC2-LiOZ9QFZaISfIeVmBEJr8V7vZcehubjVcs4ltJLs4FEF3U8WuLpF0nRWPykjPHFvyYscXfEbRfuHNhCCoRN1Kl6z_qYIR9AYsW_RGMtp6oA4ZLontH129H1_UlQ13hLJdBmkpApoFl7e7mErO27gWkC4a9uW_d0badAhJiYzSKYv4hE5YBhXpWtpNJY_kKNbD1l1tAtmPJ8rwH5I5KWs4ZzwKc4_zr2iS1NH1eidpvnDXoR05LuDdTQaZtmD4i-s-fuh_z4fAb8O8p2n9sK6oTvMIEiIOP-31FA5OaI2g4ORdHgiMisHer_QDSbE8v-Q\",\"kty\":\"RSA\",\"kid\":\"egendata://jwks/-6kHiDuSNAq5N6B8F8v3cJz2EDHnah1I-vFdve-sRNc\",\"e\":\"AQAB\"}}");
            SignedJWT signedJWT = new SignedJWT(jwsHeader, claimsSet);
            RSAKey rsaJWK = RSAKey.parse(key);
            RSASSASigner signer = new RSASSASigner(rsaJWK);
            signer.getJCAContext().setProvider(BouncyCastleProviderSingleton.getInstance());
            signedJWT.sign(signer);
            String jwt = signedJWT.serialize();


            // TODO: Implement some actually useful functionality
            promise.resolve(jwt);
        } catch (Exception ex) {
            promise.reject(ex);
        }
    }

    @ReactMethod
    public void verify(String stringArgument, int numberArgument, Promise promise) {
        System.out.println("verify is called");
        System.out.println(stringArgument);
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }

    @ReactMethod
    public void decode(String stringArgument, int numberArgument, Promise promise) {
        System.out.println("decode is called");
        System.out.println(stringArgument);
        // TODO: Implement some actually useful functionality
        promise.resolve("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }
}
