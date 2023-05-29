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
        return UIFont.init(name: self.fonts.headerRegular, size: size)!
    }
    
    public func regular(size: CGFloat) -> UIFont {
        return UIFont.init(name: self.fonts.regular, size: size)!
    }
  
}

class Styles {
    
    let fonts: Fonts = .init()
    let colors: Colors = .init()
    var style: DSSPublicStyle = .init()
    
    init(){
        
    }
    
    func updatePinStyle() -> Void {
       
       // DSSPublicStyle.global.button.medium.primary.title.backgroundColor = .init(normal: .red)
       
        let button = self.style.button
        
//        // Цвет шапки
//        UINavigationBar.appearance().tintColor = .init(red: 0.247, green: 0.796, blue: 1, alpha: 1)
//
//
//        // Цвет заголовка на скане куара сверху
//        self.style.label.qrHeader3.textColor = .init(normal: .init(normal: .white))
//        self.style.label.qrHeader3.fontSize = .init(normal: .init(normal: 17))
//        self.style.label.qrHeader3.font = .init(name: self.fonts.headerBold, size: 17)
//
//        // Кнопка на скане куара внизу
//        button.secondary.borderColor = .init(normal: .init(normal: self.colors.transparent))
//        button.secondary.title.textColor = .init(normal: .init(normal: .white, highlighted: self.colors.white_50_opacity))
//        button.secondary.title.fontSize = .init(normal: .init(normal: 15))
//        button.secondary.title.font = .init(name: self.fonts.regular, size: 15)
//        button.secondary.backgroundColor = .init(normal: .init(normal: self.colors.transparent, highlighted: self.colors.transparent))
//
//
//
//        // Заголовок на вводе пина
//        self.style.label.header.textColor = .init(normal: .init(normal: self.colors.dark))
//        self.style.label.header.fontSize = .init(normal: .init(normal: 20))
//        self.style.label.header.font = .init(name: self.fonts.headerBold, size: 20)
//
//        // Поле для ввода пина
//        let borderColor = UIColor.init(red: 0.768, green: 0.764, blue: 0.784, alpha: 1)
//        // Пустое и не активное
//        self.style.textField.textInput.textFieldStyle.empty.cornerRadius = .value(8)
//        self.style.textField.textInput.textFieldStyle.empty.backgroundColor = .init(normal: .init(normal: .white))
//        self.style.textField.textInput.textFieldStyle.empty.borderColor = .init(normal: .init(normal: borderColor))
//        // Пустое и активное
//        self.style.textField.textInput.textFieldStyle.emptyActive.cornerRadius = .value(8)
//        self.style.textField.textInput.textFieldStyle.emptyActive.backgroundColor = .init(normal: .init(normal: .white))
//        self.style.textField.textInput.textFieldStyle.emptyActive.borderColor = .init(normal: .init(normal: self.colors.blue))
//        // Заполненное и не активное
//        self.style.textField.textInput.textFieldStyle.filled.cornerRadius = .value(8)
//        self.style.textField.textInput.textFieldStyle.filled.backgroundColor = .init(normal: .init(normal: .white))
//        self.style.textField.textInput.textFieldStyle.filled.borderColor = .init(normal: .init(normal: borderColor))
//        // Заполненное и активное
//        self.style.textField.textInput.textFieldStyle.filledActive.cornerRadius = .value(8)
//        self.style.textField.textInput.textFieldStyle.filledActive.backgroundColor = .init(normal: .init(normal: .white))
//        self.style.textField.textInput.textFieldStyle.filledActive.borderColor = .init(normal: .init(normal: self.colors.blue))
//
//        // Точки в поле для ввода пина
//        self.style.numPad.dot.borderWidth = 1
//        self.style.numPad.dot.borderColor = .init(normal: .init(normal: borderColor, selected: self.colors.blue), error: .init(normal: .red, selected: .red))
//        self.style.numPad.dot.backgroundColor = .init(normal: .init(normal: .white, selected: self.colors.blue), error: .init(normal: .red, selected: .red))
//
//        self.style.textField.textInput.textColor = .init(all: .init(normal: .init(normal: self.colors.dark)))
//        self.style.textField.textInput.descriptionColor = .init(all: .init(normal: .init(normal: self.colors.grayDescription), success:.init(normal: self.colors.greenSuccess), error: .init(normal: self.colors.redError)))
//
//        // Нумпад на вводе пина
//        self.style.pinPad.number.cornerRadius = .value(5)
//        self.style.pinPad.number.borderWidth = .init(1)
//        self.style.pinPad.number.backgroundColor = .init(normal: .init(normal: .white, highlighted: self.colors.blue))
//        self.style.pinPad.number.borderColor = .init(normal: .init(normal: self.colors.blue, highlighted: .white))
//        self.style.pinPad.number.title.textColor = .init(normal: .init(normal: self.colors.blue,selected: .white, highlighted: .white))
//        self.style.pinPad.number.title.fontSize = .init(normal: .init(normal: 20))
//        self.style.pinPad.number.title.font = .init(name: self.fonts.headerBold, size: 20)
//        self.style.pinPad.delete.cornerRadius = .value(5)
////        self.style.pinPad.delete.borderWidth = .init(1)
//        self.style.pinPad.delete.backgroundColor = .init(normal: .init(normal: .white))
////        self.style.pinPad.delete.borderColor = .init(normal: .init(normal: self.colors.blue, highlighted: .white))
//        self.style.pinPad.delete.tintColor = .init(normal: .init(normal: self.colors.blue, highlighted: self.colors.disabledBlue))
//
//        // Кнопка ввести сложный пароль
//        button.triety.title.textColor = .init(normal: .init(normal: self.colors.blue))
//        button.triety.title.fontSize = .init(normal: .init(normal: 17))
//        button.triety.title.font = .init(name: self.fonts.regular, size: 17)
//        button.triety.backgroundColor = .init(normal: .init(normal: self.colors.transparent, highlighted: self.colors.transparent))
//
//        // Кнопка Продолжить
//        button.primary.backgroundColor = .init(normal: .init(normal: self.colors.blue,  highlighted: self.colors.disabledBlue, disabled: self.colors.disabledBlue))
//        button.primary.cornerRadius = .value(27)
//        button.primary.title.textColor = .init(normal: .init(normal: .white))
//        button.primary.title.fontSize = .init(normal: .init(normal: 15))
//        button.primary.title.font = .init(name: self.fonts.bold, size: 15)
//
//        // Описание профиля
//        self.style.label.title.textColor = .init(normal: .init(normal: self.colors.grayDescription))
//        self.style.label.title.fontSize = .init(normal: .init(normal: 15))
//        self.style.label.title.font = .init(name: self.fonts.regular, size: 15)
//        self.style.label.body.textColor = .init(normal: .init(normal: self.colors.dark))
//        self.style.label.body.fontSize = .init(normal: .init(normal: 17))
//        self.style.label.body.font = .init(name: self.fonts.regular, size: 17)
//
     
        
        
//            style.label.def.textColor = .init(normal: .init(normal: .green))
//            style.label.header3.textColor = .init(normal: .init(normal: .blue))
//            style.label.main.textColor = .init(normal: .init(normal: .yellow))
//            style.label.second.textColor = .init(normal: .init(normal: .lightGray))
//            style.label.qrBody.textColor = .init(normal: .init(normal: .purple))
        
        
//            style.textField.textInput.controlStyle.empty.backgroundColor = .init(normal: .init(normal: .red))
//            style.textField.textInput.controlStyle.emptyActive.backgroundColor = .init(normal: .init(normal: .yellow))
//            style.textField.textInput.controlStyle.filled.backgroundColor = .init(normal: .init(normal: .green))
//            style.textField.textInput.controlStyle.filledActive.backgroundColor = .init(normal: .init(normal: .blue))
//
        
//            style.label.def.textColor = .init(normal: .init(normal: .green))
//            style.label.header3.textColor = .init(normal: .init(normal: .blue))
//            style.label.main.textColor = .init(normal: .init(normal: .yellow))
//            style.label.title.textColor = .init(normal: .init(normal: .white))
//            style.label.body.textColor = .init(normal: .init(normal: .brown))
//            style.label.second.textColor = .init(normal: .init(normal: .lightGray))
//            style.label.qrBody.textColor = .init(normal: .init(normal: .purple))
            
        
        //style.label.qrBody.textColor = .init(normal: .init(normal: .red))
//            button.primary.tintColor = .init(normal: .init(normal: .red))
//            button.secondary.tintColor = .init(normal: .init(normal: .red))
//            button.triety.tintColor = .init(normal: .init(normal: .red))
//
//            button.primary.borderColor = .init(normal: .init(normal: .red))
//            button.secondary.borderColor = .init(normal: .init(normal: .red))
//            button.triety.borderColor = .init(normal: .init(normal: .red))
//
//            button.primary.backgroundColor = .init(normal: .init(normal: .red))
//            button.secondary.backgroundColor = .init(normal: .init(normal: .red))
//            button.triety.backgroundColor = .init(normal: .init(normal: .yellow))
//
//            style.label.def.textColor = .init(normal: .init(normal: .green))
//            style.label.header.textColor = .init(normal: .init(normal: .green))
//            style.label.header3.textColor = .init(normal: .init(normal: .green))
//            style.label.main.textColor = .init(normal: .init(normal: .green))
//            style.label.title.textColor = .init(normal: .init(normal: .green))
//            style.label.body.textColor = .init(normal: .init(normal: .green))
//            style.label.second.textColor = .init(normal: .init(normal: .green))
//            style.label.qrHeader3.textColor = .init(normal: .init(normal: .green))
//            style.label.qrBody.textColor = .init(normal: .init(normal: .green))
//
//

//            style.textField.textInput.textColor = .init(all: .init(normal: .init(normal: .green)))
//            style.textField.textInput.descriptionColor = .init(all: .init(normal: .init(normal: .green)))
//            style.textField.textInput.placeholderColor = .init(all: .init(normal: .init(normal: .green)))
//
//            style.modalWaitTintColor = .brown
//
//            style.pinPad.number.backgroundColor = .init(normal: .init(normal: .yellow))
//            style.pinPad.delete.backgroundColor = .init(normal: .init(normal: .yellow))
//
//            var switchStyle = style.switch
//            switchStyle.primary.tintColor = .init(normal: .init(normal: .brown))
//            switchStyle.primary.onTintColor = .init(normal: .init(normal: .darkGray))
//            switchStyle.checkBox.backgroundColor = .init(all: .init(normal: .init(normal: .brown)))
//
//            style.numPad.dot.backgroundColor = .init(normal: .init(normal: .yellow))
//

       
//        DSSPublicStyle.to(custom: self.style)
    }
    
    func updateProfileStyles() -> Void {
        let button = self.style.button
        
       
        let appearance = DSSPublicAppearance.init(color: DSSPublicAppearance.getLight().color, font: DSSCustomFonts.init())
    
        
        DSSPublicAppearance.to(appearance: appearance)
        
        
        
        
        
        self.updatePinStyle()
        
        // Описание профиля кнопка справа
//        button.secondary.borderColor = .init(normal: .init(normal: self.colors.blue, highlighted: self.colors.disabledBlue))
//        button.secondary.cornerRadius = .value(27)
//        button.secondary.title.textColor = .init(normal: .init(normal: self.colors.blue, highlighted: self.colors.disabledBlue))
//        button.secondary.title.fontSize = .init(normal: .init(normal: 15))
//        button.secondary.title.font = .init(name: self.fonts.bold, size: 15)
//        button.secondary.backgroundColor = .init(normal: .init(normal: .white, highlighted: .init(red: 1, green: 1, blue: 1, alpha: 0.5)))
//
        
//            style.label.def.textColor = .init(normal: .init(normal: .green))
//            style.label.header3.textColor = .init(normal: .init(normal: .blue))
//            style.label.main.textColor = .init(normal: .init(normal: .yellow))
//            style.label.second.textColor = .init(normal: .init(normal: .lightGray))
//            style.label.qrBody.textColor = .init(normal: .init(normal: .purple))
        
        
//            style.textField.textInput.controlStyle.empty.backgroundColor = .init(normal: .init(normal: .red))
//            style.textField.textInput.controlStyle.emptyActive.backgroundColor = .init(normal: .init(normal: .yellow))
//            style.textField.textInput.controlStyle.filled.backgroundColor = .init(normal: .init(normal: .green))
//            style.textField.textInput.controlStyle.filledActive.backgroundColor = .init(normal: .init(normal: .blue))
//
        
//            style.label.def.textColor = .init(normal: .init(normal: .green))
//            style.label.header3.textColor = .init(normal: .init(normal: .blue))
//            style.label.main.textColor = .init(normal: .init(normal: .yellow))
//            style.label.title.textColor = .init(normal: .init(normal: .white))
//            style.label.body.textColor = .init(normal: .init(normal: .brown))
//            style.label.second.textColor = .init(normal: .init(normal: .lightGray))
//            style.label.qrBody.textColor = .init(normal: .init(normal: .purple))
            
        
        //style.label.qrBody.textColor = .init(normal: .init(normal: .red))


//

//            style.textField.textInput.textColor = .init(all: .init(normal: .init(normal: .green)))
//            style.textField.textInput.descriptionColor = .init(all: .init(normal: .init(normal: .green)))
//            style.textField.textInput.placeholderColor = .init(all: .init(normal: .init(normal: .green)))
//
//            style.modalWaitTintColor = .brown
//

//            var switchStyle = style.switch
//            switchStyle.primary.tintColor = .init(normal: .init(normal: .brown))
//            switchStyle.primary.onTintColor = .init(normal: .init(normal: .darkGray))
//            switchStyle.checkBox.backgroundColor = .init(all: .init(normal: .init(normal: .brown)))
//
//            style.numPad.dot.backgroundColor = .init(normal: .init(normal: .yellow))
//

//        style.label.def.textColor = .init(normal: .init(normal: .green))
//        style.label.header3.textColor = .init(normal: .init(normal: .red))
//        style.label.main.textColor = .init(normal: .init(normal: .yellow))
//        style.label.second.textColor = .init(normal: .init(normal: .brown))
//        style.label.qrBody.textColor = .init(normal: .init(normal: .purple))
//
//        DSSPublicStyle.to(custom: self.style)
    }
    
    func updateSignStyles () -> Void {
        let button = self.style.button
        
        self.updateProfileStyles()
        
        // Подписание документа
//        DSSPublicStyle.global.button.large.secondary.backgroundColor = .init(normal: .red)
//        DSSPublicStyle.global.button.medium.secondary.backgroundColor = .init(normal: .red)
//        
//        button.secondary.borderColor = .init(normal: .init(normal: self.colors.transparent))
//        button.secondary.cornerRadius = .value(27)
//        button.secondary.title.textColor.normal.normal = self.colors.blue
//        button.secondary.title.fontSize = .init(normal: .init(normal: 15))
//        button.secondary.title.font = .init(name: self.fonts.bold, size: 15)
//        button.secondary.backgroundColor = .init(normal: .init(normal: self.colors.transparent))
//
//        // Попап заголовок
//        style.label.header3.textColor = .init(normal: .init(normal: self.colors.dark))
//        style.label.header3.fontSize = .init(normal: .init(normal: 17))
//        style.label.header3.font = .init(name: self.fonts.headerBold, size: 17)
//
//        style.modalWaitTintColor = self.colors.blue
//
//        style.QRCamera.body.borderWidth = 0
//
//        DSSPublicStyle.to(custom: self.style)
    }
    
    
}
