# react-native-jose

## Getting started

`$ npm install react-native-jose --save`

### Manual installation

#### iOS

1. Add this to your Podfile inside your target
```ruby
pod 'react-native-jose', :path => '../node_modules/@egendata/react-native-jose'
```

2. Add (if you haven't already or just edit existing post_install settings) in the Podfile

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'react-native-jose'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end
```

3. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.reactlibrary.JosePackage` to the imports at the top of the file
  - Add `new JosePackage()` to the list returned by the `getPackages()` method

## Usage
```javascript
import * as Jose from '@egendata/react-native-jose'

// TODO: What to do with the module?
console.log(Jose)
```

## sign

```javascript
import {sign} from '@egendata/react-native-jose'

const payload = {}
const keys = {
	jwk: {},
	der: '...'
} // private key containing "jwk" and "der" representations
const header = {}
const token = await sign(payload, keys, header)
```

## verify

```javascript
import {verify} from '@egendata/react-native-jose'

const token = '...'
const jwk = {} // public key
const payload = await verify(token, jwk)
```

## decode

```javascript
import {decode} from '@egendata/react-native-jose'

const token = '...'
const options = {} // not used currently
const {claimsSet, header, signature} = await decode(token, options)
```

## addRecipient

```javascript
import {addRecipient} from '@egendata/react-native-jose'

const jwe = {}
const ownerKeys = {
	jwk: {},
	pem: ''
} // private key containing "jwk" and "pem" representations
const recipientKeys = {
	jwk: {},
	pem: ''
} // public key containing "jwk" and "pem" representations
const alg // currently only supports "RSA-OAEP"

const newJwe = await addRecipient(payload, ownerKeys, recipientKeys, alg)
```