//
//  ConfigItem.swift
//  MasterDetailsHelloWorld
//
//  Created by Sasson, Kobi on 3/14/15.
//  Copyright (c) 2015 Sasson, Kobi. All rights reserved.
//

import Foundation
import UIKit

enum ControlsType {
    case textInput
    case colorPicker
}

enum ConfigItemType{
    case string
    case color
    case picker
    case fontPicker
    case templates
    case reset
    case language
}

class ConfigItem {
    
    var UserSettings: UserDefaults
    let key: String
    let title: String
    let type: ConfigItemType
    let defaultValue: AnyObject?
    
    var value: AnyObject? {
        get{
            switch self.type{
            case .string,.language:
                if let val = UserSettings.string(forKey: self.key) {
                    return val as AnyObject?
                } else{
                    return self.defaultValue
                }
            case .color:
                if let val = UserSettings.string(forKey: self.key) {
                    return UIColor(string: val)
                } else{
                    return defaultValue
                }
            case .templates:
                if let val = UserSettings.string(forKey: self.key) {
                    return val as AnyObject?
                } else {
                    return self.defaultValue
                }
            default:
                if let val = UserSettings.string(forKey: self.key) {
                    return val as AnyObject?
                } else{
                    return self.defaultValue
                }
            }
        }
        set {
            switch self.type{
            case .string,.language:
                UserSettings.set(newValue, forKey: self.key)
                UserSettings.synchronize()
            case .color:
                if let color = (newValue as! UIColor).stringValue {
                    
                    if(self.key == KEY_ISSIE_KEYBOARD_KEYS_COLOR){
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR)
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR)
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR)
                        UserSettings.synchronize()
                    }
                    else if(self.key == KEY_ISSIE_KEYBOARD_TEXT_COLOR){
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR)
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR)
                        UserSettings.set(color, forKey: KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR)
                        UserSettings.synchronize()
                    }
                    else
                    {
                        UserSettings.set(color, forKey: self.key)
                        UserSettings.synchronize()
                    }
                }
            default:
                UserSettings.set(newValue, forKey: self.key)
                UserSettings.synchronize()
            }
        }
    }
    
    init(key:String ,title: String, defaultValue: AnyObject?, type: ConfigItemType ){
        UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        self.key = key
        self.title = title
        self.type = type
        self.defaultValue = defaultValue
        
        let val = UserSettings.string(forKey: self.key)
        if (val != nil) {
            return
        }
        switch self.type{
        case .reset: break
        case .string,.language:
            UserSettings.set(defaultValue, forKey: self.key)
            UserSettings.synchronize()
        case .color:
            if let color = (defaultValue as! UIColor).stringValue {
                UserSettings.set(color, forKey: self.key)
                UserSettings.synchronize()
            }
        default:
            UserSettings.set(defaultValue, forKey: self.key)
            UserSettings.synchronize()
        }
    }
}
