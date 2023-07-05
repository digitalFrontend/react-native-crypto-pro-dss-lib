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
    
    static func convertUserDevices(device: DSSDeviceInfo) -> [String:Any] {
    
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
    private var lastAuth: DSSAuth_V2? = nil;
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
                
                let cpd = DSSCryptoProDss();
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
            
        var operations = [] as [Any];
            
        Task {
            do {
                let operationsInfo:DSSFramework.DSSOperationsInfo = try await DSSPolicy_V2.shared.getOperations(kid: kid, type: nil, opId: nil)
                
                for _operation in operationsInfo.operations ?? [] {
                    operations.append(try! DictionaryEncoder.encode(_operation))
                }
                resolve(operations)
                
            } catch {
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getOperations)")
            }
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
            
            
        self.styles.updateSignStyles()
        
        Task {
            do {
                let operationsInfo:DSSFramework.DSSOperationsInfo = try await DSSPolicy_V2.shared.getOperations(kid: kid, type: nil, opId: nil);
                var operation = nil as DSSFramework.DSSOperation?;
                
                for _operation in operationsInfo.operations ?? [] {
                    if (transactionId == _operation.transactionId) {
                        operation = _operation;
                    }
                }
                
                do {
                    let (approveRequestMT, _) = try await DSSSign_V2.shared.signMT(kid: kid, operation: operation, enableMultiSelection: false, confirmationSendingMode: DSSFramework.DSSConfirmationSendingMode.offline)
                    
                    do {
                        try await DSSSign_V2.shared.deferredRequest(kid: kid, approveRequest: approveRequestMT!);
                        
                        let forReturn = try! DictionaryEncoder.encode(approveRequestMT);
                        
                        resolve(forReturn);
                    } catch {
                        self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (deferredRequest)")
                    }
                } catch {
                    print(error)
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (signMT)")
                }
                
            } catch {
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getOperations.signMT)")
            }
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
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
                authList = try DSSAuth_V2.shared.getAuthList()
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
            
        var list = [] as [Any];
            
        Task {
            do {
                var devices:DSSDevices = try await DSSPolicy_V2.shared.getUserDevices(kid: kid);
            
                for device in devices.devices {
                    list.append(DictionaryEncoder.convertUserDevices(device: device));
                }
                resolve(list);
            } catch {
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (getUserDevices)");
            }
        }
    }
    
    @objc
    func continueInitViaQr(
            _ kid: String,
            withResolver resolve: @escaping RCTPromiseResolveBlock,
            withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
            
            jsPromiseResolver = resolve;
            jsPromiseRejecter = reject;
                
                
            Task {
                do {
                    try await DSSAuth_V2.shared.confirm(kid: kid);
                    
                    self.styles.updateProfileStyles();
                    do {
                        try await DSSAuth_V2.shared.verifyDevice(kid: kid,silent: false);
                        resolve(String(format: "success"));
                    } catch {
                        self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (auth.verify)");
                    }
                } catch {
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (auth.confirm)");
                }
            }
    }
    
    
    
    @objc
    func initViaQr(
        _ base64: String?,
        withUseBiometric useBiometric: Bool,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
            
            self.styles.updateQRStyle();
                
            let user = DSSUser();
            let registerInfo = DSSRegisterInfo();
            
            
            Task {
                do {
                    try await DSSAuth_V2.shared.scanAndAddQR();
                    
                    self.styles.updatePinStyle();
                    self.styles.updateProfileStyles();
                    
                    try await DSSAuth_V2.shared.kInit(dssUser: user, registerInfo: registerInfo, keyProtectionType: DSSFramework.DSSProtectionType.PASSWORD);
                    resolve(String(format: "success"));
                } catch {
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (initViaQr)");
                }
            }
         
        }
}
