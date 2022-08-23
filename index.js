import { NativeModules } from 'react-native';

const { CryptoProDssLib } = NativeModules;

let waitPromise = delay => new Promise(resolve => {
    setTimeout(() => {
        resolve(null)
    }, delay)
})

let CryptoProDss = {
    sdkInitialization: () => CryptoProDssLib.sdkInitialization(),
    getOperations: (kid) => CryptoProDssLib.getOperations(kid),
    signMT: (transactionId, kid) => new Promise((resolve, reject) => {
        CryptoProDssLib.switchHeader(true)
        CryptoProDssLib.signMT(transactionId, kid).then((response) => {
            waitPromise(1000).then(() => {
                CryptoProDssLib.switchHeader(false)
                resolve(response)
            })
        }).catch(err => {
            waitPromise(1000).then(() => {
                CryptoProDssLib.switchHeader(false)
                reject(err)
            })
        })
    }),
    updateStyles: () => CryptoProDssLib.updateStyles(),
    getUsers: () => CryptoProDssLib.getUsers(),
    getUserDevices: (kid) => CryptoProDssLib.getUserDevices(kid),
    continueInitViaQr: (kid) => CryptoProDssLib.continueInitViaQr(kid),
    initViaQr: (qr, useBiometric) => CryptoProDssLib.initViaQr(qr, useBiometric),
    deferredRequest: (kid) => CryptoProDssLib.deferredRequest(kid)
}


export default CryptoProDss;
