import { NativeModules } from 'react-native'
// import jwkToPem from 'jwk-to-pem'
const { Jose } = NativeModules

function pem2der(key) {
  return key
    .replace(/(?:\r\n|\r|\n)/g, '')
    .replace('-----BEGIN RSA PRIVATE KEY-----', '')
    .replace('-----END RSA PRIVATE KEY-----', '')
    .replace('-----BEGIN RSA PUBLIC KEY-----', '')
    .replace('-----END RSA PUBLIC KEY-----', '')
}

function keys(jwk) {
  return { jwk, der: pem2der(jwk) }
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
    r => r.header.kid === ownerKey.kid
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
      kid: recipientKey.kid,
      alg
    },
    encrypted_key: newEncryptedKey
  })
  return jwe
}
