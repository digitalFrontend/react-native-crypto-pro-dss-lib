// CryptoProDssLib.swift

import Foundation
import DSSFramework
import DSSFrameworkSupport
import UIKit

class Fonts {
    let headerBold = "Tele2DisplaySerifWebSHORT-Bold"
    let headerRegular = "Tele2DisplaySerifWebSHORT-Reg"
    let bold = "Tele2TextSansSHORT-Bold"
    let regular = "Tele2TextSansSHORT-Regular"
}

class Colors {
    let dark = UIColor.init(red: 0.121, green: 0.133, blue: 0.160, alpha: 1)
    let blue = UIColor.init(red: 0.247, green: 0.796, blue: 1, alpha: 1)
    let disabledBlue = UIColor.init(red: 0.631, green: 0.901, blue: 1, alpha: 1)
    let greenSuccess = UIColor.init(red: 0.239, green: 0.831, blue: 0.619, alpha: 1)
    let grayDescription = UIColor.init(red: 0.560, green: 0.576, blue: 0.6, alpha: 1)
    let redError = UIColor.init(red: 1, green: 0.27, blue: 0.36, alpha: 1)
    let transparent = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    let white_50_opacity = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
}

public class DSSCustomFonts : DSSFramework.DSSPublicFontProtocol {

    let fonts: Fonts = .init()
    
  
    
    public func bold(size: CGFloat) -> UIFont {
            return UIFont.init(name: self.fonts.headerBold, size: size)!
    }

    public func semiBold(size: CGFloat) -> UIFont {
        return UIFont.init(name: self.fonts.bold, size: size)!
    }
    
    public func medium(size: CGFloat) -> UIFont {
        return UIFont.init(name: self.fonts.regular, size: size)!
    }
    
    public func regular(size: CGFloat) -> UIFont {
        return UIFont.init(name: self.fonts.regular, size: size)!
    }
  
}

class Styles {
    
    let fonts: Fonts = .init()
    let colors: Colors = .init()
    var style: DSSPublicStyle = .init()
    var map: [String: Any] = [String:Any]()
    
    init(){
        
    }
    
    func updateQRStyle() -> Void {
        
        
        var lightTheme = DSSPublicColorStyle.getLight()
        
        
        lightTheme.bg.header = .init(hex: "3fcbffff")
        lightTheme.bg.modal = .init(hex: "ffffffff")
        lightTheme.bg.tabBarLine = .init(hex: "3fcbffff")
        lightTheme.button.primary = .init(hex: "3fcbffff")
        lightTheme.button.primaryPressed = .init(hex: "a1e6ffff")
        lightTheme.button.secondary = .init(hex: "ff0000ff")
        lightTheme.button.secondaryPressed = .init(hex: "ff0000ff")
        lightTheme.status.blue = .init(hex: "3fcbffff")
        lightTheme.text.links = .init(hex: "3fcbffff")
        lightTheme.text.tabBar = .init(hex: "3fcbffff")
        lightTheme.text.primary = .init(hex: "ffffffff")
        lightTheme.text.description = .init(hex: "ffffffff")
        
        
        //Применяем цвет
        let appearance1 = DSSPublicAppearance.init(color: lightTheme, font: DSSCustomFonts.init())
        DSSPublicAppearance.to(appearance: appearance1)
        
        //
        
        let button = self.style.button
        
    }
    
    
    func updatePinStyle() -> Void {
        
        self.updateQRStyle()
    
        
        var lightTheme = DSSPublicColorStyle.getLight()
        
        
        lightTheme.bg.header = .init(hex: "3fcbffff")
        lightTheme.bg.modal = .init(hex: "ff0000ff")
        lightTheme.bg.tabBarLine = .init(hex: "3fcbffff")
        lightTheme.button.primary = .init(hex: "3fcbffff")
        lightTheme.button.primaryPressed = .init(hex: "a1e6ffff")
        lightTheme.button.secondary = .init(hex: "E5EFF9FF")
        lightTheme.button.secondaryPressed = .init(hex: "CEE0F2FF")
        lightTheme.status.blue = .init(hex: "3fcbffff")
        lightTheme.text.links = .init(hex: "3fcbffff")
        lightTheme.text.tabBar = .init(hex: "3fcbffff")
        lightTheme.text.primary = .init(hex: "1f2229ff")
        lightTheme.text.description = .init(hex: "1f2229ff")
        
     
        
        
        //Применяем цвет
        let appearance1 = DSSPublicAppearance.init(color: lightTheme, font: DSSCustomFonts.init())
        DSSPublicAppearance.to(appearance: appearance1)
        
        //
        
        let button = self.style.button
        
    }
    
    func logColor(color: UIColor, name: String) -> Void{
        self.map.updateValue(color.hexString, forKey: name)
    }
    

    func test() -> [String: Any] {
        
    
        
        return self.map
    }
    
    func updateProfileStyles() -> Void {
        
        self.updatePinStyle()
    
        
        let button = self.style.button
        var lightTheme = DSSPublicColorStyle.getLight()
        lightTheme.bg.header = .init(hex: "3fcbffff")
        lightTheme.bg.modal = .init(hex: "ffffffff")
        lightTheme.bg.tabBarLine = .init(hex: "3fcbffff")
        lightTheme.button.primary = .init(hex: "3fcbffff")
        lightTheme.button.primaryPressed = .init(hex: "a1e6ffff")
        lightTheme.button.secondary = .init(hex: "E5EFF9FF")
        lightTheme.button.secondaryPressed = .init(hex: "CEE0F2FF")
        lightTheme.status.blue = .init(hex: "3fcbffff")
        lightTheme.text.links = .init(hex: "3fcbffff")
        lightTheme.text.tabBar = .init(hex: "3fcbffff")
        lightTheme.text.primary = .init(hex: "1f2229ff")
        lightTheme.text.description = .init(hex: "1f2229ff")
        //Применяем цвет
        let appearance1 = DSSPublicAppearance.init(color: lightTheme, font: DSSCustomFonts.init())
        DSSPublicAppearance.to(appearance: appearance1)
   
    }
    
    func updateSignStyles () -> Void {
        let button = self.style.button
        
        self.updateProfileStyles()
        var lightTheme = DSSPublicColorStyle.getLight()
        
   
        
        lightTheme.bg.header = .init(hex: "3fcbffff")
        lightTheme.bg.modal = .init(hex: "00000080")
        lightTheme.bg.tabBarLine = .init(hex: "3fcbffff")
        lightTheme.button.primary = .init(hex: "3fcbffff")
        lightTheme.button.primaryPressed = .init(hex: "a1e6ffff")
        lightTheme.button.secondary = .init(hex: "E5EFF9FF")
        lightTheme.button.secondaryPressed = .init(hex: "CEE0F2FF")
        lightTheme.status.blue = .init(hex: "3fcbffff")
        lightTheme.text.links = .init(hex: "3fcbffff")
        lightTheme.text.tabBar = .init(hex: "3fcbffff")
        lightTheme.text.primary = .init(hex: "1f2229ff")
        lightTheme.text.description = .init(hex: "1f2229ff")
     
       
        
        //Применяем цвет
        let appearance1 = DSSPublicAppearance.init(color: lightTheme, font: DSSCustomFonts.init())
        DSSPublicAppearance.to(appearance: appearance1)
        
      
    }
    
    
}

extension UIColor {
    var hexString: String {
        let components = self.cgColor.components!
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(components[3])

        let hex = String(
            format: "%02X%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255),
            Int(a * 255)
        )

        return hex
    }
}


extension UIColor {
    convenience init(hex: String) {
        var hexWithoutPrefix = hex
            
            // Remove any "#" character from the beginning of the string
            if hex.hasPrefix("#") {
                hexWithoutPrefix = String(hex.dropFirst())
            }
            
            // Convert the hex string to a UInt32 value
            guard let hexValue = UInt32(hexWithoutPrefix, radix: 16) else {
                self.init(red: 0, green: 0, blue: 0, alpha: 1)
                return
            }
            
            // Separate the components of the value
            let red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            let green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            let blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            let alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            
            // Create and return the UIColor object
            self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
