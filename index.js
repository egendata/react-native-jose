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
  return { jwk: keys.jwk, der: pem2der(keys.pem) }
}

export const sign = async (payload, privateKeys, header) => {
  return Jose.sign(payload, keys(privateKeys), header)
}

export const verify = Jose.verify
export const decode = Jose.decode

export const addRecipient = async (
  jwe,
  ownerKeys,
  recipientKeys,
  alg = 'RSA-OAEP'
) => {
  const { encrypted_key } = jwe.recipients.find(
    r => r.header.kid === ownerKeys.jwk.kid
  )
  if (!encrypted_key) {
    throw new Error('no matching recipient for owner key')
  }
  const newEncryptedKey = await Jose.reEncryptCek(
    encrypted_key,
    keys(ownerKeys),
    keys(recipientKeys),
    alg
  )

  jwe.recipients.push({
    header: {
      kid: recipientKeys.jwk.kid,
      alg
    },
    encrypted_key: newEncryptedKey
  })
  return jwe
}
