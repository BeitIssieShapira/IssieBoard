//
//  MasterViewController.swift
//  IssieKeyboard
//
//  Created by Sasson, Kobi on 3/17/15.
//  Copyright (c) 2015 Sasson, Kobi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController	 {
    
    var detailViewController: DetailViewController? = nil
    var loadSaveViewController: ConfigSetsTableViewController? = nil
    let preferedLanguage  = MasterViewController.getPreferredLanguage()
    var data = [
        ConfigSection(title: wrapWithLocale(TITLE_MAIN_SETTINGS) ,
            items: [
                ConfigItem(key:KEY_ISSIE_KEYBOARD_RESET ,title: wrapWithLocale(TITLE_KEYBOARD_RESET) ,
                    defaultValue: UIColor.red,type: ConfigItemType.reset),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_LANGUAGES ,title: wrapWithLocale(TITLE_KEYBOARD_LANGUAGES) ,
                    defaultValue:  MasterViewController.getPreferredLanguage() as AnyObject?,type: ConfigItemType.language),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR ,title: wrapWithLocale(TITLE_KEYBOARD_BACKGROUND) ,
                    defaultValue: UIColor.lightGray,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_KEYS_COLOR,title: wrapWithLocale(TITLE_COLOR_OF_KEYS),
                    defaultValue: UIColor.brown,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                    defaultValue: UIColor.brown,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_VISIBLE_KEYS,title:wrapWithLocale(TITLE_VISIBLE_KEYS),
                    defaultValue: "" as AnyObject?,type: ConfigItemType.string),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN,title:wrapWithLocale(TITLE_COLS_VS_ROWS),
                    defaultValue: "By Sections" as AnyObject?,type: ConfigItemType.picker) ]),
        
        ConfigSection(title: wrapWithLocale(TITLE_UPPER_RIGHT) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS),
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT),
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_MIDDLE) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT),
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_LOWER_LEFT) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_SPECIAL_KEYS_DEF) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT,title:wrapWithLocale(TITLE_SPECIAL_KEYS) ,
                defaultValue: "" as AnyObject?,type: ConfigItemType.string),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_TEMPLATE) ,
            items: [
            //    ConfigItem(key:KEY_ISSIE_KEYBOARD_TEMPLATES,title:wrapWithLocale(TITLE_TEMPLATE_SELECTION) ,
            //    defaultValue: "My Configuration" , type: ConfigItemType.Templates),
                    ConfigItem(key:KEY_ISSIE_KEYBOARD_SAVE_LOAD,title:wrapWithLocale(TITLE_SAVE_LOAD) ,
                    defaultValue: UIColor.cyan,    type: ConfigItemType.color)
            ]),
        
        ConfigSection(title: wrapWithLocale(TITLE_ADDITIONAL_DEFS) ,
            items: [
                ConfigItem(key:KEY_ISSIE_KEYBOARD_SPACE_COLOR,title:wrapWithLocale(TITLE_COLOR_SPACE_KEY) ,
                    defaultValue: UIColor.cyan,type: ConfigItemType.color)  ,
                ConfigItem(key:KEY_ISSIE_KEYBOARD_BACKSPACE_COLOR,title:wrapWithLocale(TITLE_COLOR_DELETE_KEY) ,
                    defaultValue: UIColor.cyan,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_ENTER_COLOR,title:wrapWithLocale(TITLE_COLOR_ENTER_KEY) ,
                    defaultValue: UIColor.cyan,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OTHER_KEYS) ,
                    defaultValue: UIColor.cyan,    type: ConfigItemType.color)
            ])]
    
    func getData() -> [ConfigSection]
    {
        return data
    }
    
    static func getPreferredLanguage()->String{
        let preferedLanguage  = NSLocale.preferredLanguages[0]
        if((preferedLanguage == "he-IL")||preferedLanguage == "he-US"){
            return "HE"
        }
        else {
            return "EN"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitTemplates.loadDefaultTemplates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if(segue.identifier == "ShowInfoPDF"){
        //
        //}
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = data[indexPath.section].items[indexPath.row] as ConfigItem
                
                if(object.key == KEY_ISSIE_KEYBOARD_SAVE_LOAD){
                   // performSegueWithIdentifier("loadSave", sender: detailViewController)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                   // controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()//<<
                   // controller.navigationItem.leftItemsSupplementBackButton = true//<<
                    controller.performSegue()
                    
                } else {
                 let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                controller.configItem = object
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        }
        
       if segue.identifier == "loadSave"{
        //let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        //controller.navigationItem.setHidesBackButton(false, animated: false)
        //let loadSaveController = ConfigSetsTableViewController()
        //let navController = segue.sourceViewController as! UINavigationController
        
        //let navController = splitViewController.detailViewController?.navigationController
       // navController!.pushViewController(loadSaveController, animated: true)
             /*   let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ConfigSetsTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            splitViewController?.showDetailViewController(loadSaveController, sender: self)*/
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return data[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        let section = data[indexPath.section]
        let items = section.items;
        let item: ConfigItem = items[indexPath.row]
        
        cell.textLabel!.text = item.title
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func backFromTemplates(_ segue: UIStoryboardSegue){
    
    }
}



// TITLES
let TITLE_MAIN_SETTINGS       = "Main";
let TITLE_KEYBOARD_BACKGROUND = "KeyboardBackground";
let TITLE_COLOR_OF_KEYS       = "KeysColor";
let TITLE_COLOR_OF_TEXT       = "TextColor";
let TITLE_VISIBLE_KEYS        = "VisibleKeys";
let TITLE_COLS_VS_ROWS        = "Columns_Rows";
let TITLE_SPECIAL_KEYS        = "SpecialKeys";

let TITLE_SPECIAL_KEYS_DEF    = "SpecialKeysDefinition";
let TITLE_UPPER_RIGHT         = "UpperRight";
let TITLE_MIDDLE              = "Middle";
let TITLE_LOWER_LEFT          = "LowerLeft";

let TITLE_TEMPLATE            = "Templates";
let TITLE_TEMPLATE_SELECTION  = "TemplatesSelection";

let TITLE_ADDITIONAL_DEFS     = "AdditionalDefinitions";
let TITLE_COLOR_SPACE_KEY     = "SpaceKeyColor";
let TITLE_COLOR_DELETE_KEY    = "DeleteKeyColor";
let TITLE_COLOR_ENTER_KEY     = "EnterKeyColor";
let TITLE_COLOR_OTHER_KEYS    = "OtherKeysColor";

let TITLE_PALETTE_RAINBOW     = "RainbowColors";
let TITLE_PALETTE_CLASSIC     = "ClassicColors";
let TITLE_PALETTE_BW          = "BlackAndWhite";

let TITLE_NEW_KEYBOARD        = "NewKeyboard";
let TITLE_SAVE_LOAD           = "SaveAndLoadCustomTemplates";
let TITLE_KEYBOARD_RESET      = "Reset"
let TITLE_KEYBOARD_LANGUAGES  = "Languages"
let TITLE_KEYBOARD_RESET_BUTTON   = "ResetToDefaultKeyboard"
let TITLE_KEYBOARD_RESET_DONE = "ResetToDefaultKeyboardDone"
let TITLE_KEYBOARD_LOADED     = "KeyboardSuccessfullyLoaded"
let KEY_ISSIE_KEYBOARD_SAVE_LOAD  = "KEY_ISSIE_KEYBOARD_SAVE_LOAD";

let TITLE_SHOW_KEYBOARD     = "ShowKeyboard"
let TITLE_HIDE_KEYBOARD     = "HideKeyboard"
let TITLE_CONFIGURATIONS    = "Configurations"
//KEYS

let KEY_ISSIE_KEYBOARD_RESET                   = "KEY_ISSIE_KEYBOARD_RESET"
let KEY_ISSIE_KEYBOARD_LANGUAGES               = "ISSIE_KEYBOARD_LANGUAGES"
let KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR        = "ISSIE_KEYBOARD_BACKGROUND_COLOR";
let KEY_ISSIE_KEYBOARD_KEYS_COLOR              = "ISSIE_KEYBOARD_KEYS_COLOR";
let KEY_ISSIE_KEYBOARD_TEXT_COLOR              = "ISSIE_KEYBOARD_TEXT_COLOR";
let KEY_ISSIE_KEYBOARD_VISIBLE_KEYS            = "ISSIE_KEYBOARD_VISIBLE_KEYS";
let KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN           = "ISSIE_KEYBOARD_ROW_OR_COLUMN";
let KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR";
let KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR";
let KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR";
let KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR";
let KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR     = "ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR";
let KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR     = "ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR";
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT       = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT";
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR      = "ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR";
let KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR = "ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR";
let KEY_ISSIE_KEYBOARD_TEMPLATES               = "ISSIE_KEYBOARD_TEMPLATES";
let KEY_ISSIE_KEYBOARD_SPACE_COLOR             = "ISSIE_KEYBOARD_SPACE_COLOR";
let KEY_ISSIE_KEYBOARD_ENTER_COLOR             = "ISSIE_KEYBOARD_ENTER_COLOR";
let KEY_ISSIE_KEYBOARD_BACKSPACE_COLOR         = "ISSIE_KEYBOARD_BACKSPACE_COLOR";
let KEY_ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR  = "ISSIE_KEYBOARD_OTHERDEFAULTKEYS_COLOR";

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
func wrapWithLocale (_ titleToWrap:String) -> String
{
    //let forDebug = NSBundle.mainBundle().localizedStringForKey( titleToWrap, value: titleToWrap,table:nil);
   // return NSLocalizedString(titleToWrap, comment: titleToWrap)
    return Bundle.main.localizedString( forKey: titleToWrap, value: titleToWrap,table:nil);
}

func isIPad()->Bool{
    return  UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
}

func isIpadPro() -> Bool
{
    if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
        (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366)) {
            return true
    }
    return false
}
/* FYI, here's the hebrew titles
let TITLE_MAIN_SETTINGS       = "הגדרות ראשיות";
let TITLE_KEYBOARD_BACKGROUND = "רקע המקלדת";
let TITLE_COLOR_OF_KEYS       = "צבע המקשים";
let TITLE_COLOR_OF_TEXT       = "צבע הטקסט";
let TITLE_VISIBLE_KEYS        = "מקשים נראים";
let TITLE_COLS_VS_ROWS        = "שורות-עמודות";
let TITLE_SPECIAL_KEYS        = "מקשים מיוחדים";

let TITLE_SPECIAL_KEYS_DEF    = "הגדרות מקשים מיוחדים";
let TITLE_UPPER_RIGHT         = "ימינה-למעלה";
let TITLE_MIDDLE              = "אמצע";
let TITLE_LOWER_LEFT          = "שמאלה-למטה";

let TITLE_TEMPLATE            = "תבניות";
let TITLE_TEMPLATE_SELECTION  = "בחירת תבנית";

let TITLE_ADDITIONAL_DEFS     = "הגדרות נוספות";
let TITLE_COLOR_SPACE_KEY     = "צבע מקש הרווח";
let TITLE_COLOR_DELETE_KEY    = "צבע מקש מחיקה";
let TITLE_COLOR_ENTER_KEY     = "צבע מקש ירידת שורה";
let TITLE_COLOR_OTHER_KEYS    = "צבע מקשים נוספים";

let TITLE_PALETTE_RAINBOW     = "Rainbow Colors";
let TITLE_PALETTE_CLASSIC     = "Classic Colors";
let TITLE_PALETTE_BW          = "BW Colors";
*/
