//
//  Settings.swift
//  EducKeyboard
//
//  Created by Maman, Omri on 2/27/15.
//  Copyright (c) 2015 sap. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    
    private static var __once: () = {
            Static.instance = Settings()
        }()
    
    
    static func ifNeededSetToDefault(userDefaults:UserDefaults){
        let UserSettings = userDefaults
        let cString: String? = UserSettings.string(forKey: KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR)
      //  if(cString == nil){
      //      Settings.resetToDefaultTemplate(userDefaults: userDefaults)
      //  }
    }
    
    static func resetToDefaultTemplate(userDefaults:UserDefaults){
        let UserSettings = userDefaults
        let bundlePath = Bundle.main.path(forResource: "DocumentationDefaultTemplates1", ofType: "plist")
        let templateDictionary1 = NSMutableDictionary(contentsOfFile: bundlePath!)
        
        
        var fullArray = Constants.KEYS_ARRAY
        fullArray.append("configurationName")

        for key in fullArray{
            let currentValue = templateDictionary1?.value(forKey: key)
            if(currentValue != nil){
                UserSettings.setValue(currentValue, forKey:key)
            }
        }
        UserSettings.synchronize()
    }
    
    var Template1 : KeyboardTemplates
    var Template2 : KeyboardTemplates
    var Template3 : KeyboardTemplates
    var Template4 : KeyboardTemplates
    
    init() {
        self.userDefaults = UserDefaults(suiteName: KeyboardViewController.groupName)!
        Settings.ifNeededSetToDefault(userDefaults: self.userDefaults)
        Template1 = KeyboardTemplates(
            keyboardBackgroundColor: UIColor.lightGray.stringValue!,
            keysTextColor: UIColor.black.stringValue!,
            keysTextColorCharset1: UIColor.black.stringValue!,
            keysTextColorCharset2: UIColor.black.stringValue!,
            keysTextColorCharset3: UIColor.black.stringValue!,
            keysColorCharset1: UIColor.yellow.stringValue!,
            keysColorCharset2: UIColor.yellow.stringValue!,
            keysColorCharset3: UIColor.yellow.stringValue!,
            RowOrCol: "By Sections")
        
        Template2 = KeyboardTemplates(
            keyboardBackgroundColor: UIColor.orange.stringValue!,
            keysTextColor: UIColor.blue.stringValue!,
            keysTextColorCharset1: UIColor.blue.stringValue!,
            keysTextColorCharset2: UIColor.blue.stringValue!,
            keysTextColorCharset3: UIColor.blue.stringValue!,
            keysColorCharset1: UIColor.white.stringValue!,
            keysColorCharset2: UIColor.white.stringValue!,
            keysColorCharset3: UIColor.white.stringValue!,
            RowOrCol: "By Sections")
        /*
        Template3 = KeyboardTemplates(
            keyboardBackgroundColor: UIColor.lightGrayColor().stringValue!,
            keysTextColor: UIColor.blackColor().stringValue!,
            keysTextColorCharset1: UIColor.blackColor().stringValue!,
            keysTextColorCharset2: UIColor.blackColor().stringValue!,
            keysTextColorCharset3: UIColor.blackColor().stringValue!,
            keysColorCharset1: UIColor.yellowColor().stringValue!,
            keysColorCharset2: UIColor.yellowColor().stringValue!,
            keysColorCharset3: UIColor.yellowColor().stringValue!,
            RowOrCol: "By Sections")
        */
        // KEYS: 180,131,82
        // BG:   152,131,88
        // SPACE,ENTER: 79,200,209
        // NUMBERS, CHANGE KEYBOARD: 57,104,172
        
        Template3 = KeyboardTemplates(
            keyboardBackgroundColor: UIColor.lightGray  .stringValue!,
            keysTextColor: UIColor.black.stringValue!,
            keysTextColorCharset1: UIColor.black.stringValue!,
            keysTextColorCharset2: UIColor.black.stringValue!,
            keysTextColorCharset3: UIColor.black.stringValue!,
          //  keysColorCharset1: UIColor(red: 180, green: 131, blue: 82) .stringValue!,
          //  keysColorCharset2: UIColor (red: 180.0/255.0, green: 131.0/255.0, blue: 82/255.0, alpha: 1.0).stringValue!,
            keysColorCharset1: UIColor.orange.stringValue!,
            keysColorCharset2: UIColor.orange.stringValue!,
            keysColorCharset3: UIColor.orange.stringValue!,
            RowOrCol: "By Sections")
        
        Template4 = KeyboardTemplates(
            keyboardBackgroundColor: UIColor.lightGray.stringValue!,
            keysTextColor: UIColor.black.stringValue!,
            keysTextColorCharset1: UIColor.black.stringValue!,
            keysTextColorCharset2: UIColor.black.stringValue!,
            keysTextColorCharset3: UIColor.black.stringValue!,
            keysColorCharset1: UIColor.yellow.stringValue!,
            keysColorCharset2: UIColor.yellow.stringValue!,
            keysColorCharset3: UIColor.yellow.stringValue!,
            RowOrCol: "By Sections")
        
        
    }
    var userDefaults : UserDefaults
    
    class var sharedInstance: Settings {
        

        
        _ = Settings.__once
        
        return Static.instance!
    }
    struct Static {
        static var onceToken: Int = 0
        static var instance: Settings? = nil
    }
    var allCharsInKeyboard : String {
        get{
            let enKeys = "QWERTYUIOPASDFGHJKLZXCVBNM"
            return "אבגדהוזחטיכלמנסעןפצקרשתםףךץ1234567890.,?!'•_\\|~<>$€£[]{}#%^*+=.,?!'\"-/:;()₪&@" + enKeys + enKeys.lowercased()
        }
    }
    
    var defaultBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_BACKGROUND_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysOneBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysTwoBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysThreeBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysOneBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysTwoBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysThreeBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var visibleKeys : String {
        get {
            if userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS") == nil{
                return ""
            }
            else{
                let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS")!
                return cString
            }
        }
    }
    
    var SpecialKeyColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    
    var SpecialKeyTextColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var SpecialKeys : String {
        get {
            if userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT") == nil{
                return ""
            }
            else{
                let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT")!
                return cString
            }
        }
    }
    
    var RowOrCol : String {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_ROW_OR_COLUMN")!
            return cString
        }
    }
    
    var Font : String {
        get {
            if userDefaults.string(forKey: "ISSIE_KEYBOARD_FONT") == nil{
                return "Arial"
            }
            else{
                let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_FONT")!
                return cString
            }
        }
    }
    
    
    var currentTemplate : String {
        get {
    
                let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_TEMPLATES")!
                return cString
        }
    }
    
    
    /// FIXED KEYS COLORS - START ///
    
    var SpaceColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPACE_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var BackspaceColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_BACKSPACE_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var EnterColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_ENTER_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    var OtherKeysColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR")!
            return UIColor(rgba: cString)
        }
    }
    
    /// FIXED KEYS COLORS - END///
    
    
    // AREA KEYBOARD COLORS - START//
    
    var AreaKeyboard1 : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "AREA_KEYBOARD_1")!
            return UIColor(rgba: cString)
        }
    }

    var AreaKeyboard2 : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "AREA_KEYBOARD_2")!
            return UIColor(rgba: cString)
        }
    }

    var AreaKeyboard3 : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "AREA_KEYBOARD_3")!
            return UIColor(rgba: cString)
        }
    }

    var AreaKeyboard4 : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "AREA_KEYBOARD_4")!
            return UIColor(rgba: cString)
        }
    }

    var AreaKeyboard5 : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "AREA_KEYBOARD_5")!
            return UIColor(rgba: cString)
        }
    }
    
    // AREA KEYBOARD COLORS - END//

    
    
    
    
    func GetKeyColorByTemplate (_ model : Key) -> UIColor {
        
        var TemplateType = ["Template1 - Yellow", "Template2 - Orange", "Template3", "Template4"]
        
        switch self.currentTemplate {
        case TemplateType[0]:
            
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: self.Template1.KeysColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: self.Template1.KeysColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: self.Template1.KeysColorCharset3)
            default:
                return UIColor(string: self.Template1.KeysColorCharset3)
            }
            
        case TemplateType[1]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: self.Template2.KeysColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: self.Template2.KeysColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: self.Template2.KeysColorCharset3)
            default:
                return UIColor(string: self.Template2.KeysColorCharset3)
            }
            
        case TemplateType[2]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: self.Template3.KeysColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: self.Template3.KeysColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: self.Template3.KeysColorCharset3)
            default:
                return UIColor(string: self.Template3.KeysColorCharset3)
            }
            
        case TemplateType[3]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: self.Template4.KeysColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: self.Template4.KeysColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: self.Template4.KeysColorCharset3)
            default:
                return UIColor(string: self.Template4.KeysColorCharset3)
            }
        default:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return self.charsetKeysOneBackgroundColor
            case Key.KeyType.customCharSetTwo:
                return self.charsetKeysTwoBackgroundColor
            case Key.KeyType.customCharSetThree:
                return self.charsetKeysThreeBackgroundColor
            default:
                return self.charsetKeysThreeBackgroundColor
            }
        }
    }
    
    func GetKeyTextColorByTemplate(_ model : Key) -> UIColor {
        
        var TemplateType = ["Template1 - Yellow", "Template2 - Orange", "Template3", "Template4"]
        
        switch self.currentTemplate {
        case TemplateType[0]:
            
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: Template1.KeysTextColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: Template1.KeysTextColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: Template1.KeysTextColorCharset3)
            default:
                return UIColor(string: Template1.KeysTextColorCharset3)
            }
            
        case TemplateType[1]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: Template2.KeysTextColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: Template2.KeysTextColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: Template2.KeysTextColorCharset3)
            default:
                return UIColor(string: Template2.KeysTextColorCharset3)
            }
            
        case TemplateType[2]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: Template3.KeysTextColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: Template3.KeysTextColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: Template3.KeysTextColorCharset3)
            default:
                return UIColor(string: Template3.KeysTextColorCharset3)
            }
            
        case TemplateType[3]:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return UIColor(string: Template4.KeysTextColorCharset1)
            case Key.KeyType.customCharSetTwo:
                return UIColor(string: Template4.KeysTextColorCharset2)
            case Key.KeyType.customCharSetThree:
                return UIColor(string: Template4.KeysTextColorCharset3)
            default:
                return UIColor(string: Template4.KeysTextColorCharset3)
            }
        default:
            switch model.type {
            case Key.KeyType.customCharSetOne:
                return self.charsetTextKeysOneBackgroundColor
            case Key.KeyType.customCharSetTwo:
                return self.charsetTextKeysTwoBackgroundColor
            case Key.KeyType.customCharSetThree:
                return self.charsetTextKeysThreeBackgroundColor
            default:
                return self.charsetTextKeysThreeBackgroundColor
            }
        }
    }
    
    func GetBackgroundColorByTemplate() -> UIColor {
        
        var TemplateType = ["Template1 - Yellow", "Template2 - Orange", "Template3", "Template4"]
        
        switch self.currentTemplate {
        case TemplateType[0]:
            return UIColor(string: Template1.KeyboardBackgroundColor)
        case TemplateType[1]:
            return UIColor(string: Template2.KeyboardBackgroundColor)
        case TemplateType[2]:
            return UIColor(string: Template3.KeyboardBackgroundColor)
        case TemplateType[3]:
            return UIColor(string: Template4.KeyboardBackgroundColor)
        default:
            return self.defaultBackgroundColor
        }
    }
    
}

let KEY_ISSIE_KEYBOARD_RESET                   = "KEY_ISSIE_KEYBOARD_RESET"
let KEY_ISSIE_KEYBOARD_LANGUAGES               = "ISSIE_KEYBOARD_LANGUAGES"
let KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR        = "ISSIE_KEYBOARD_BACKGROUND_COLOR"
let KEY_ISSIE_KEYBOARD_KEYS_COLOR              = "ISSIE_KEYBOARD_KEYS_COLOR"
let KEY_ISSIE_KEYBOARD_TEXT_COLOR              = "ISSIE_KEYBOARD_TEXT_COLOR"
let KEY_ISSIE_KEYBOARD_VISIBLE_KEYS            = "ISSIE_KEYBOARD_VISIBLE_KEYS"
let KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN           = "ISSIE_KEYBOARD_ROW_OR_COLUMN"
let KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR"
let KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR"
let KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR"
let KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR"
let KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR"
let KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR"
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT       = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT"
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR      = "ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR"
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR"
let KEY_ISSIE_KEYBOARD_TEMPLATES               = "ISSIE_KEYBOARD_TEMPLATES"
let KEY_ISSIE_KEYBOARD_SPACE_COLOR             = "ISSIE_KEYBOARD_SPACE_COLOR"
let KEY_ISSIE_KEYBOARD_ENTER_COLOR             = "ISSIE_KEYBOARD_ENTER_COLOR"
let KEY_ISSIE_KEYBOARD_BACKSPACE_COLOR         = "ISSIE_KEYBOARD_BACKSPACE_COLOR"
let KEY_ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR  = "ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR"

public  struct Constants{
    
    public static let KEYS_ARRAY = [
        KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR        ,
        KEY_ISSIE_KEYBOARD_KEYS_COLOR              ,
        KEY_ISSIE_KEYBOARD_TEXT_COLOR              ,
        KEY_ISSIE_KEYBOARD_VISIBLE_KEYS            ,
        KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN           ,
        KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR     ,
        KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR     ,
        KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR     ,
        KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR     ,
        KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR     ,
        KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR     ,
        KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT       ,
        KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR      ,
        KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR ,
        KEY_ISSIE_KEYBOARD_TEMPLATES               ,
        KEY_ISSIE_KEYBOARD_SPACE_COLOR             ,
        KEY_ISSIE_KEYBOARD_ENTER_COLOR             ,
        KEY_ISSIE_KEYBOARD_BACKSPACE_COLOR         ,
        KEY_ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR,
        KEY_ISSIE_KEYBOARD_LANGUAGES
    ]
}

