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
}

@objc(CryptoProDssLib)
class CryptoProDssLib : UIViewController {
    
    private var jsPromiseResolver: RCTPromiseResolveBlock? = nil;
    private var jsPromiseRejecter: RCTPromiseRejectBlock? = nil;
    private var lastAuth: Auth? = nil;
    private var lastRequest: ApproveRequestMT? = nil;
    private var lastView: UIViewController? = nil;
    
    @objc
    func sdkInitialization(
        _ resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            guard let rootVC = UIApplication.shared.delegate?.window??.visibleViewController, (rootVC.navigationController != nil) else {
                 reject("E_INIT", "Error getting rootViewController", NSError(domain: "", code: 200, userInfo: nil))
                 return
            }
            
            let cpd = CryptoProDss();
            cpd._init(view: rootVC) { code in
                
                resolve("inited")
            }
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
                 reject("E_INIT", "Error getting rootViewController", NSError(domain: "", code: 200, userInfo: nil))
                 return
            }
            
            let policy = Policy();
            
            policy.getOperations(view: rootVC, kid: kid, type: nil, opId: nil){ operationsInfo,error  in
                
                if (error != nil){
                    reject(error?.localizedDescription,error?.localizedDescription,error?.localizedDescription);
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
                 reject("E_INIT", "Error getting rootViewController", NSError(domain: "", code: 200, userInfo: nil))
                 return
            }
            
            
            let policy = Policy();
            let sign = Sign();
            policy.getOperations(view: rootVC, kid: kid, type: nil, opId: nil){ operationsInfo,error  in
                
                var operation = nil as SDKFramework.Operation?;
                
                for _operation in operationsInfo?.operations ?? [] {
                  
                    if (transactionId == _operation.transactionId) {
                        operation = _operation;
                    }
                }
                
                self.tryToSwitchHeader(true);
                sign.signMT(view: rootVC, kid: kid, operation: operation, enableMultiSelection: false, inmediateSendConfirm: false, silent: false){ approveRequestMT,error  in
                    
                    self.tryToSwitchHeader( false);
                    
                    self.lastRequest = approveRequestMT;
                    self.lastView = rootVC;
                    
                    if (error != nil){
                        reject(error?.localizedDescription,error?.localizedDescription,error?.localizedDescription);
                    } else {
                        let forReturn = try! DictionaryEncoder.encode(self.lastRequest);
                        
                        resolve(forReturn);
                    }
                    
                }
            }
       }
        
    }
    
    
    @objc
    func deferredRequest(
        _ kid: String,
        withResolver resolve: @escaping RCTPromiseResolveBlock,
        withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        jsPromiseResolver = resolve;
        jsPromiseRejecter = reject;
        
        DispatchQueue.main.async {
            
            
            
            let policy = Policy();
            let sign = Sign();
            
            sign.deferredRequest(view: self.lastView!, kid: kid, approveRequest: self.lastRequest!){ error in
                resolve("success");
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
                print(authList, authList.count)
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
                reject("cant load styles","cant load styles","cant load styles");
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
            
            
            self.tryToSwitchHeader(false);
            var authList = [] as [DSSUser];
            do {
                authList = try Auth.getAuthList();
            } catch {
                print("getUsers error")
                print(error)
            }
            
            var list = [] as [Any]
            
            for user in authList {
                list.append(DictionaryEncoder.convertDssUser(user: user));
            }
            
            resolve(list)
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
                         reject("E_INIT", "Error getting rootViewController", NSError(domain: "", code: 200, userInfo: nil))
                         return
                    }
                    
                    self.lastAuth!.confirm(view: rootVC, kid: kid) { error in
                        if error != nil {
                            self.tryToSwitchHeader(false);
                            reject("auth confirm - failed", error as! String, "auth confirm - failed")
                    
                        } else {
                            self.lastAuth!.verify(view: rootVC, kid: kid, silent: false) { error in
                                self.tryToSwitchHeader(false);
                                if error != nil {
                                    reject("auth verify - failed", error as! String, "auth verify - failed")
                             
                                } else {
                                    resolve(String(format: "success"))
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print("continueInitViaQr error")
                    print(error)
                    
                    reject("continueInitViaQr - error", error as! String, "continueInitViaQr - error")
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
                     reject("E_INIT", "Error getting rootViewController", NSError(domain: "", code: 200, userInfo: nil))
                     return
                }
                
                let user = DSSUser();
                let registerInfo = RegisterInfo();
                
                self.lastAuth!.scanQR(view: rootVC, base64QR: base64)  { type, error in
                    if error != nil {
                        reject("scanQr - failed", "scanQr - failed", "scanQr - failed")
                    } else {
                        self.tryToSwitchHeader(true);
                        self.lastAuth!.kinit(view: rootVC, dssUser: user, registerInfo: registerInfo, keyProtectionType: useBiometric ? SDKFramework.ProtectionType.BIOMETRIC : SDKFramework.ProtectionType.PASSWORD, activationCode: nil, password: nil) { error in
                            
                            if error != nil {
                                self.tryToSwitchHeader(false);
                                reject("kinit - failed", error as! String, "kinit - failed")
                            } else {
                                resolve(String(format: "success"))
                            }
                        }
                    }
                }
                
            } catch {
                print("scanQR error")
                print(error)
                reject("scanQr - error", "scanQr - error", "scanQr - error")
                   
            }
                  
        }
    }
}


public extension UIWindow {
    func tryToSwitchHeader(_ state: Bool) -> UIViewController? {
        self.window?.makeKeyAndVisible()
        let vc = self.rootViewController;
        if let nc = vc as? UINavigationController {
            nc.setNavigationBarHidden(!state, animated: false);
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

