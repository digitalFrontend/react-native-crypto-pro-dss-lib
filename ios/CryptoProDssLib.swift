// CryptoProDssLib.swift

import Foundation
import SDKFramework
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
    private var lastAuth: Auth? = nil;
    
    private func reject(rejectFunc: @escaping RCTPromiseRejectBlock, text: String) -> Void {
        rejectFunc("CryptoProDssLib", text, text);
    }
    
    @objc
    func sdkInitialization(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
      
        DispatchQueue.main.async {
            guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                 self.reject(rejectFunc: reject, text: "Error getting rootViewController(sdkInitialization)")
                 return
            }
            
            
            let cpd = CryptoProDss();
            cpd._init(view: rootVC) { code in
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
            self.tryToSwitchHeader(state)
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
            guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                self.reject(rejectFunc: reject, text: "Error getting rootViewController(getOperations)")
                
                 return
            }
            
            let policy = Policy();

            policy.getOperations(view: rootVC, kid: kid, type: nil, opId: nil){ operationsInfo,error  in

                if (error != nil){
                    self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (getOperations)")
                } else {
                    var operations = [] as [Any];
                    
                    for _operation in operationsInfo?.operations ?? [] {
                        operations.append(try! DictionaryEncoder.encode(_operation))
                    }
                    
                   resolve(operations)
                }
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
        
        DispatchQueue.main.async {
            guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                self.reject(rejectFunc: reject, text: "Error getting rootViewController (signMT)")
                 return
            }
            

            let policy = Policy();
            let sign = Sign();
            policy.getOperations(view: rootVC, kid: kid, type: nil, opId: nil){ operationsInfo,error  in
                
                if (error != nil){
                    self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (getOperations.signMT)")
                    return;
                }
                
                var operation = nil as SDKFramework.Operation?;

                for _operation in operationsInfo?.operations ?? [] {

                    if (transactionId == _operation.transactionId) {
                        operation = _operation;
                    }
                }

                //self.tryToSwitchHeader(true);
                sign.signMT(view: rootVC, kid: kid, operation: operation, enableMultiSelection: false, inmediateSendConfirm: false, silent: false){ approveRequestMT,error  in
                    
                    //self.tryToSwitchHeader( false);
                    
                    if (error != nil){
                        self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (signMT)")
                    } else {

                        sign.deferredRequest(view: rootVC, kid: kid, approveRequest: approveRequestMT!){ error in
                            
                            if (error != nil){
                                self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (deferredRequest)")
                                return;
                            }
                            
                            //self.tryToSwitchHeader( false);
                            let forReturn = try! DictionaryEncoder.encode(approveRequestMT);
                                                    
                            resolve(forReturn);
                        }
                    }
                    
                }
            }
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
    func updateStyles(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            let policy = Policy();

            do {
                try policy.setPersonalisation(url: Bundle.main.url(forResource: "SDKStyles", withExtension:"json")!)

                resolve("updateStyles success");
            } catch {
                self.reject(rejectFunc: reject, text: "cant load styles (updateStyles)")
            }
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
            
            guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                
                self.reject(rejectFunc: reject, text: "Error getting rootViewController (getUserDevices)")
                 return
            }
            
            let policy = Policy();
            
            policy.getUserDevices(view: rootVC, kid: kid){
                devices,error  in

                if (error != nil){
                    self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (getUserDevices)")
                } else {
                    var list = [] as [Any]

                    
                    for device in devices!.devices {
                        list.append(DictionaryEncoder.convertUserDevices(device: device));
                    }
                    
                    resolve(list)
                }
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
           
            DispatchQueue.main.async {
                    
                do {
                    let rootViewController = UIApplication.shared.delegate?.window??.rootViewController

                    guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                        self.reject(rejectFunc: reject, text: "Error getting rootViewController (continueInitViaQr)")
                         return
                    }
                    
                    self.lastAuth!.confirm(view: rootVC, kid: kid) { error in
                        if error != nil {
                            //self.tryToSwitchHeader(false);
                            self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (auth.confirm)")

                        } else {
                            self.lastAuth!.verify(view: rootVC, kid: kid, silent: false) { error in
                                //self.tryToSwitchHeader(false);
                                if error != nil {
                                    self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (auth.verify)")

                                } else {
                                    resolve(String(format: "success"))
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print("continueInitViaQr error")
                    print(error)
                    
                    self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (continueInitViaQr)")
                }
            }
    }
    
    func tryToSwitchHeader(
        _ state: Bool
    ) -> Void {
        UIApplication.shared.delegate?.window??.tryToSwitchHeader(state)
    }
    
    @objc
    func initViaQr(
        _ base64: String?,
        withUseBiometric useBiometric: Bool,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
       
        DispatchQueue.main.async {
                
            do {
               self.lastAuth = try Auth()
                
                guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                    self.reject(rejectFunc: reject, text: "Error getting rootViewController (initViaQr)")
                     return
                }
                
                let user = DSSUser();
                let registerInfo = RegisterInfo();

                self.lastAuth!.scanQR(view: rootVC, base64QR: base64) {
                    type, url, error in
                    if error != nil {
                        self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (scanQR)")
                    } else {
                        //self.tryToSwitchHeader(true);
                        self.lastAuth!.kinit(view: rootVC, dssUser: user, registerInfo: registerInfo, keyProtectionType: useBiometric ? SDKFramework.ProtectionType.BIOMETRIC : SDKFramework.ProtectionType.PASSWORD, activationCode: nil, password: nil) { kid, error  in

                            if error != nil {
                                //self.tryToSwitchHeader(false);
                                self.reject(rejectFunc: reject, text: "\(error!.localizedDescription) (kinit)")
                            } else {
                                resolve(String(format: "success"))
                            }
                        }
                    }
                }
                
            } catch {
                print("scanQR error")
                print(error)
                self.reject(rejectFunc: reject, text: "\(error.localizedDescription) (initViaQr)")
                   
            }
                  
        }
    }
}


public extension UIWindow {
    func tryToSwitchHeader(_ state: Bool) -> UIViewController? {
        self.window?.makeKeyAndVisible()
        let vc = self.rootViewController;
        if let nc = vc as? UINavigationController {
            
            if (state){
                if #available(iOS 15, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(red: 63/255.0, green: 203/255.0, blue: 255.0/255.0, alpha: 1.0)

                    appearance.titleTextAttributes = [
                        NSAttributedString.Key.foregroundColor: UIColor.white,
                        NSAttributedString.Key.font: UIFont(name: "Tele2DisplaySerifWebSHORT-Bold", size: 17)!]
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            
            nc.setNavigationBarHidden(!state, animated: false);
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
    
    var visibleViewController: UIViewController? {
        self.window?.makeKeyAndVisible()
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}


