// CryptoProDssLib.swift

import Foundation
import SDKFramework
import UIKit


class NavigationDelegate : SDKNavigationDelegate {
    
    private var window: UIWindow? = nil;
    private var mainVC: UIViewController? = nil;
    
    //
    
    init(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.window = appDelegate?.window
    }
    
    func needShow(navigationController: SDKNavigationController, animated: Bool, completion: @escaping (() -> Void)) {
        guard let window = self.window else { return }
        self.mainVC = window.rootViewController

        window.rootViewController = navigationController
        

        let options: UIView.AnimationOptions = .transitionCrossDissolve
        UIView.transition(with: window, duration: 0.2, options: options, animations: {}, completion:
                            { completed in
            completion()
        })
    }
    
    func needHide(navigationController: SDKNavigationController, animated: Bool, completion: @escaping (() -> Void)) {
        print("needHide")
        guard let window = self.window else { return }
        guard let mainVC = self.mainVC else { return }
        window.rootViewController = mainVC

        let options: UIView.AnimationOptions = .transitionCrossDissolve
        UIView.transition(with: window, duration: 0.2, options: options, animations: {}, completion:
                            { completed in
            completion()
        })
    }
    
    func needShowLoading() {
        print("needShowLoading")
       
    }
    
    func needHideLoading() {
        print("needHideLoading")
    }
    
    
}
