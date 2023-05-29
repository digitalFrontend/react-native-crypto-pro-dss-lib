// CryptoProDssLib.swift

import Foundation
import DSSFramework
import UIKit


struct DictionaryEncoder {
    static func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
        let jsonData = try JSONEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    }
    
    static func convertDssUser(user: DSSUser) -> [String:Any] {
        
        var map = [String:Any]()
        
        let kid : String = user.kid;
        let uid : String = user.uid;

        map.updateValue(kid, forKey: "kid");
        map.updateValue(uid, forKey: "uid");
        
        return map;
    }
    
    static func convertUserDevices(device: DeviceInfo) -> [String:Any] {
        
        var map = [String:Any]()
        
        let kid : String = device.kid;
        let uid : String = device.uid;
        let profile : String = device.profile!;
        let deviceName : String = device.deviceName!;

        map.updateValue(kid, forKey: "kid");
        map.updateValue(uid, forKey: "uid");
        map.updateValue(profile, forKey: "profile");
        map.updateValue(deviceName, forKey: "deviceName");
        
        return map;
    }
}

@objc(CryptoProDssLib)
class CryptoProDssLib : UIViewController {
    
    private var jsPromiseResolver: RCTPromiseResolveBlock? = nil;
    private var jsPromiseRejecter: RCTPromiseRejectBlock? = nil;
    private var navigationDelegate: NavigationDelegate? = nil;
    private var lastAuth: Auth? = nil;
    private weak var showingNC: UINavigationController?;
    
    private var styles: Styles = .init()
    
    private func reject(rejectFunc: @escaping RCTPromiseRejectBlock, text: String) -> Void {
        rejectFunc("CryptoProDssLib", text, text as? Error);
    }
    
    @objc
    func sdkInitialization(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
            jsPromiseResolver = resolve;
            jsPromiseRejecter = reject;
            
           
      
            DispatchQueue.main.async {
                
                self.navigationDelegate = NavigationDelegate()
                
                DSSNavigation.shared.delegate = self.navigationDelegate
                DSSNavigation.shared.modalLoadingForSilentRequestType = .outer
                
                
                
                let cpd = CryptoProDss();
                cpd._init() { code in
                    resolve(CSPInitCode.init_ok.rawValue)
                }
           }
    }
    
    @objc
    func switchHeader(
        _ state: Bool,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
          
            resolve(nil)
       }
    }
    
    @objc
    func getOperations(
        _ kid: String,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            
            
            
            Policy.shared.getOperations(kid: kid, type: nil, opId: nil, successCompletion: {
                (operationsInfo) in
                var operations = [] as [Any];
                
                for _operation in operationsInfo.operations ?? [] {
                    operations.append(try! DictionaryEncoder.encode(_operation))
                }
                
               resolve(operations)
            }, errorCompletion: {
                (error) in
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getOperations)")
            })

       }
        
    }
    
    @objc
    func signMT(
        _ transactionId: String,
        withKid kid: String,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            self.styles.updateSignStyles()
            
            let sign = Sign();
            Policy.shared.getOperations(kid: kid, type: nil, opId: nil, successCompletion: {
                (operationsInfo) in
                var operation = nil as DSSFramework.Operation?;

                for _operation in operationsInfo.operations ?? [] {

                    if (transactionId == _operation.transactionId) {
                        operation = _operation;
                    }
                }
           
                sign.signMT(kid: kid, operation: operation, enableMultiSelection: false, inmediateSendConfirm: false, silent: false, successCompletion: {
                    (approveRequestMT, state) in
                    
                    sign.deferredRequest(kid: kid, approveRequest: approveRequestMT!, successCompletion: {
                        () in
                            let forReturn = try! DictionaryEncoder.encode(approveRequestMT);
                                                
                            resolve(forReturn);
                    }, errorCompletion: {
                        (error) in
                            self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (deferredRequest)")
                    })
                }, errorCompletion: {
                    (error) in
                        print(error)
                        //if (error.localizedDescription != "User cancelled"){
                        self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (signMT)")
                        //}
                })
            }, errorCompletion: {
                (error) in
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getOperations.signMT)")
            })
            
            
         
       }
        
    }
    
    
   
    
    override func viewDidLoad() {
            super.viewDidLoad()
    }
    
    func getLastUserKid() -> String? {
            
        var authList = [] as [DSSUser];
            do {
                authList = try Auth.getAuthList();
                
                let lastUser = authList[authList.count-1];
                return lastUser.kid;
            } catch {

            }
        return nil;
    }
    
    @objc
    func initialization() -> Void {
        
        print("initialization");
    }
    
    
    @objc
    func updateStyles(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            
            resolve("Now not required");
           
       }
    }
    
    
    @objc
    func getUsers(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
            
        
        DispatchQueue.main.async {
            
            
            var authList = [] as [DSSUser];
            do {
                authList = try Auth.getAuthList();
            } catch {
                
            }
            
            var list = [] as [Any]
            
            for user in authList {
                list.append(DictionaryEncoder.convertDssUser(user: user));
            }
            
            resolve(list)
       }
    }
    
    @objc
    func getUserDevices(
        _ kid: String,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
            
        
        DispatchQueue.main.async {
            Policy.shared.getUserDevices(kid: kid, successCompletion: {
                (devices) in
                    var list = [] as [Any]

                    
                    for device in devices.devices {
                        list.append(DictionaryEncoder.convertUserDevices(device: device));
                    }
                    
                    resolve(list)
            }, errorCompletion: {
                (error) in
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getUserDevices)")
            })
       }
    }
    
    @objc
    func continueInitViaQr(
            _ kid: String,
            withResolver resolve: @escaping RCTPromiseResolveBlock,
            withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
            
            jsPromiseResolver = resolve;
            jsPromiseRejecter = reject;
           
            DispatchQueue.main.async {
                    
                do {
                    Auth().confirm(kid: kid) { error in
                        if error != nil {
                            
                            self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (auth.confirm)")

                        } else {
                            self.styles.updateProfileStyles()
                            Auth().verify(kid: kid, silent: false, successCompletion: {
                                () in
                                resolve(String(format: "success"))
                            }, errorCompletion: {
                                type in
                                self.reject(rejectFunc: reject, text: "\(type) (auth.verify)")
                            })
                        }
                    }
                    
                    
                } catch {
                    print("continueInitViaQr error")
                    print(error)
                    
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (continueInitViaQr)")
                }
            }
    }
    
    
    
    @objc
    func initViaQr(
        _ base64: String?,
        withUseBiometric useBiometric: Bool,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
            
                self.styles.updatePinStyle()
                
                let user = DSSUser();
                let registerInfo = RegisterInfo();
                
                Task {
                    do {
                        try await Auth_V2.shared.scanAndAddQR()
                        self.styles.updateProfileStyles()
                        try await Auth_V2.shared.kInit(dssUser: user,
                                                       registerInfo: registerInfo,
                                                       keyProtectionType:  DSSFramework.ProtectionType.PASSWORD)
                        resolve(String(format: "success"))
                    } catch {
                        reject("CryptoProDssLib", "\(error.localizedDescription)", "\(error.localizedDescription)" as? Error);
                    }
                }
         
        }
}
