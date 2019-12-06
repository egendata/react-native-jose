import { NativeModules } from 'react-native'
const { Jose } = NativeModules

function pem2der(key) {
  return key
    .replace(/(?:\r\n|\r|\n)/g, '')
    .replace('-----BEGIN RSA PRIVATE KEY-----', '')
    .replace('-----END RSA PRIVATE KEY-----', '')
    .replace('-----BEGIN RSA PUBLIC KEY-----', '')
    .replace('-----END RSA PUBLIC KEY-----', '')
}

function keys(keys) {
  return { jwk: keys.jwk, privateDer: pem2der(keys.privateKey), publicDer: pem2der(keys.publicKey) }
}

export const sign = Jose.sign
export const verify = Jose.verify
export const decode = Jose.decode

export const addRecipient = async (
  jwe,
  ownerKey,
  recipientKey,
  alg = 'RSA-OAEP'
) => {
  const { encrypted_key } = jwe.recipients.find(
    r => r.header.kid === ownerKey.jwk.kid
  )
  if (!encrypted_key) {
    throw new Error('no matching recipient for owner key')
  }
  const newEncryptedKey = await Jose.reEncryptCek(
    encrypted_key,
    keys(ownerKey),
    keys(recipientKey),
    alg
  )

  jwe.recipients.push({
    header: {
      kid: recipientKey.jwk.kid,
      alg
    },
    encrypted_key: newEncryptedKey
  })
  return jwe
}
