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
        let cString: String? = UserSettings.string(forKey: Constants.KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR)
        if(cString == nil){
            Settings.resetToDefaultTemplate(userDefaults: userDefaults)
        }
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
        UserSettings.setValue(getPreferredLanguage(), forKey:Constants.KEY_ISSIE_KEYBOARD_LANGUAGES)
        //UserSettings.synchronize()//UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
    }

    init() {
        self.userDefaults = UserDefaults(suiteName: KeyboardViewController.groupName)!
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
            let arKeys = "ضصقفغعهخحجشسيبلاتنمكظطذدزروةث"
            let arNumbers = "؟١٢٣٤٥٦v٨٩٠"
            let arPunctuation = "  ً ٰ ـ ُ ِ َ ّ ٌ ً ٍ ْ"
            return "אבגדהוזחטיכלמנסעןפצקרשתםףךץ1234567890.,?!'•_\\|~<>$€£[]{}#%^*+=.,?!'\"-/:;()₪&@" + enKeys + enKeys.lowercased() + arKeys + arNumbers + arPunctuation
        }
    }
    
    var defaultBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: Constants.KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR) ?? Constants.BACKGROUND_COLOR_GRAY
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysOneBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR") ?? Constants.KEY_COLOR_YELLOW
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysTwoBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR") ?? Constants.KEY_COLOR_YELLOW
            return UIColor(rgba: cString)
        }
    }
    
    var charsetKeysThreeBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR") ?? Constants.KEY_COLOR_YELLOW
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysOneBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR") ?? Constants.TEXT_COLOR_BLUE
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysTwoBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR") ?? Constants.TEXT_COLOR_BLUE
            return UIColor(rgba: cString)
        }
    }
    
    var charsetTextKeysThreeBackgroundColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR") ?? Constants.TEXT_COLOR_BLUE
            return UIColor(rgba: cString)
        }
    }
    
    var visibleKeys : String {
       /* get {
            if userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS") == nil{
                return ""
            }
            else{
                let cString:String? = userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS")
                return cString!
            }
        }
 */
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS") ?? ""
            return cString
        }
    }
    
    var SpecialKeyColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR") ?? Constants.KEY_COLOR_YELLOW
            return UIColor(rgba: cString)
        }
    }
    
    
    var SpecialKeyTextColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR") ?? Constants.TEXT_COLOR_BLUE
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
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_ROW_OR_COLUMN") ?? "By Sections"
            return cString
        }
    }
    
    var Language : String {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_LANGUAGES") ?? Settings.getPreferredLanguage()
            return cString
        }
    }
    
    var Font : String {
        get {
            if userDefaults.string(forKey: "ISSIE_KEYBOARD_FONT") == nil{
                return "Arial-BoldMT"
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
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_SPACE_COLOR") ?? Constants.KEY_COLOR_CYAN
            return UIColor(rgba: cString)
        }
    }
    
    var BackspaceColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_BACKSPACE_COLOR") ?? Constants.KEY_COLOR_CYAN
            return UIColor(rgba: cString)
        }
    }
    
    var EnterColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_ENTER_COLOR") ?? Constants.KEY_COLOR_CYAN
            return UIColor(rgba: cString)
        }
    }
    
    var OtherKeysColor : UIColor {
        get {
            let cString: String = userDefaults.string(forKey: "ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR") ?? Constants.KEY_COLOR_CYAN
            return UIColor(rgba: cString)
        }
    }
    
    
    func GetKeyColorByTemplate (_ model : Key) -> UIColor {
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
    
    func GetKeyTextColorByTemplate(_ model : Key) -> UIColor {
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
    
    func GetBackgroundColorByTemplate() -> UIColor {
        return self.defaultBackgroundColor
    }
    
    static func getPreferredLanguage()->String{
        let preferedLanguage  = NSLocale.preferredLanguages[0]
        if((preferedLanguage == "he-IL")||preferedLanguage == "he-US"){
            return "HE"
        }
        else if((preferedLanguage == "ar-IL")||preferedLanguage == "ar-US"){
            return "AR"
        }
        else {
            return "EN"
        }
    }
}
/*
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
*/
public struct Constants{
  
    public static let KEY_ISSIE_KEYBOARD_RESET                   = "KEY_ISSIE_KEYBOARD_RESET"
    public static let KEY_ISSIE_KEYBOARD_LANGUAGES               = "ISSIE_KEYBOARD_LANGUAGES"
    public static let KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR        = "ISSIE_KEYBOARD_BACKGROUND_COLOR"
    public static let KEY_ISSIE_KEYBOARD_KEYS_COLOR              = "ISSIE_KEYBOARD_KEYS_COLOR"
    public static let KEY_ISSIE_KEYBOARD_TEXT_COLOR              = "ISSIE_KEYBOARD_TEXT_COLOR"
    public static let KEY_ISSIE_KEYBOARD_VISIBLE_KEYS            = "ISSIE_KEYBOARD_VISIBLE_KEYS"
    public static let KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN           = "ISSIE_KEYBOARD_ROW_OR_COLUMN"
    public static let KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR"
    public static let KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR"
    public static let KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR"
    public static let KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR"
    public static let KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR"
    public static let KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR"
    public static let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT       = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT"
    public static let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR      = "ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR"
    public static let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR"
    public static let KEY_ISSIE_KEYBOARD_TEMPLATES               = "ISSIE_KEYBOARD_TEMPLATES"
    public static let KEY_ISSIE_KEYBOARD_SPACE_COLOR             = "ISSIE_KEYBOARD_SPACE_COLOR"
    public static let KEY_ISSIE_KEYBOARD_ENTER_COLOR             = "ISSIE_KEYBOARD_ENTER_COLOR"
    public static let KEY_ISSIE_KEYBOARD_BACKSPACE_COLOR         = "ISSIE_KEYBOARD_BACKSPACE_COLOR"
    public static let KEY_ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR  = "ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR"
    
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
    
    public static let KEY_COLOR_YELLOW         = "1.0000,1.0000,0.0000,1.0000"
    public static let TEXT_COLOR_BLUE          = "0.0000,0.0000,1.0000,1.0000"
    public static let BACKGROUND_COLOR_GRAY    = "0.6667,0.6667,0.6667,1.0000"
    public static let KEY_COLOR_CYAN           = "0.0000,1.0000,1.0000,1.0000"
    
    let customTwoCharSetOne : String = "@&₪$٨٩٠098'\""
    let customTwoCharSetTwo : String = "٥٦v765;()?؟!"
    let customTwoCharSetThree : String = ".,4123١٢٣٤-/:"
    
    let customThreeCharSetOne : String = "*+=$€£'•"
    let customThreeCharSetTwo : String = "?!~<>#%^"
    let customThreeCharSetThree : String = ",.[]{}_\\|"
    
    // Settings - By Row Strings //
    let customKeyboardOneRowOneHE : String = ",.קראטוןםפ"
    let customKeyboardOneRowTwoHE : String = "שדגכעיחלךף"
    let customKeyboardOneRowThreeHE : String = "זסבהנמצתץ"
    
    public static let customKeyboardOneRowOneAR : String = "ضصقفغعهخحج"
    let customKeyboardOneRowTwoAR : String = "شسيبلاتنمك"
    let customKeyboardOneRowThreeAR : String = "ظطذدزروةث"
    
    let customKeyboardOneRowOneEN : String = "qwertyuiop"
    let customKeyboardOneRowTwoEN : String = "asdfghjkl"
    let customKeyboardOneRowThreeEN : String = "zxcvbnm,."
    
    public static let customCharSetOneAR : String = " خ ح ج ن م كو ة ث"
    public static let customCharSetTwoAR : String = " ف غ ع هب ل ا تد ز ر"
    public static let customCharSetThreeAR : String = "ض ص قش س يظ ط ذ"
    
    //Sets of english letters: Right/Middle/Left
    public static let customCharSetOneEN : String = "IOPJKLM,."
    public static let customCharSetTwoEN : String = "RTYUFGHVBN"
    public static let customCharSetThreeEN : String = "QWEASDZXC"
    
    //Sets of hebrewׄׄׄ letters: Right/Middle/Left
    public static let customCharSetOneHE : String = "פםןףךלץתצ"
    public static let customCharSetTwoHE : String = "וטאחיעמנה"
    public static let customCharSetThreeHE : String = "רקכגדשבסז,."
    
    public static let dynamicRowsOfKeysAR = Constants.customKeyboardOneRowOneAR.components(separatedBy:[])
    public static let rowsOfKeysAR = [
        [ "ض", "ص", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج"]
        ,
        [ "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك"]
        ,
        [ "ظ", "ط", "ذ", "د", "ز", "ر", "و", "ة", "ث"]
    ]
    public static let rowsOfKeysHE = [
        [ ",", ".", "ק", "ר", "א", "ט", "ו", "ן", "ם", "פ"]
        ,
        ["ש", "ד", "ג", "כ", "ע", "י", "ח", "ל", "ך", "ף"]
        ,
        [ "ז", "ס", "ב", "ה", "נ", "מ", "צ", "ת", "ץ"]
    ]
    public static let rowsOfKeysEN = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M",",","."]]
}

