//
//  EditConfigViewController.swift
//  IssieBoard
//
//  Created by Uriel on 19/03/2016.
//  Copyright © 2016 sap. All rights reserved.
//

import UIKit
import CoreData
class EditConfigViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    var configSet: NSManagedObject!
    var prevConfigSet: NSManagedObject!
    var UserSettings: UserDefaults!
    var updateCellDelegate:UpdateCellsDelegate!
    var rollbackRequired:Bool = true
    
    @IBOutlet weak var loadKeyboardButton: UIButton!
    @IBOutlet weak var textField: UITextField!    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!

    static func getTranslateConfigurationName(configSet:NSManagedObject!)->String{
        let rawValue = configSet.value(forKey: "configurationName") as? String
        if (MasterViewController.getPreferredLanguage() == "HE"){
            return rawValue!
        }
        else {
            switch rawValue!{
            case "תבנית מוכנה 1 - ברירת מחדל" :
                return "Predefined Keyboard 1 - Default"
            case "תבנית מוכנה 2":
                return "Predefined Keyboard 2"
            case "תבנית מוכנה 3":
                return "Predefined Keyboard 3"
            default:
                return rawValue!
            }
        }
        return ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.becomeFirstResponder()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        if configSet != nil {
            self.textField.text = EditConfigViewController.getTranslateConfigurationName(configSet: configSet)
            //configSet.value(forKey: "configurationName") as? String
            let titleString = String(format: "%@", self.textField.text!)
            self.title = titleString
            self.loadKeyboardButton.isHidden = false
            setPreviousConfigForCancelationCase()
            updateCurrentDeviceStateByCurrentConfigSet()
            
        } else{
            self.title = wrapWithLocale(TITLE_NEW_KEYBOARD)
            self.loadKeyboardButton.isHidden = true
            rollbackRequired = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(rollbackRequired){
            configSet = prevConfigSet
            updateCurrentDeviceStateByCurrentConfigSet()
        }
    }
    
    @IBAction func loadButtonClicked(_ sender: UIButton) {
        rollbackRequired = false;
        configSet.setValue(self.textField.text, forKey: "configurationName")
        updateCurrentDeviceStateByCurrentConfigSet();
        updateCellDelegate.updateCheckedCell()
        let newTitle = wrapWithLocale(TITLE_KEYBOARD_LOADED)
        UIView.transition(with: loadKeyboardButton, duration: 0.6, options: [.transitionFlipFromTop ], animations: {self.loadKeyboardButton.setTitle(newTitle, for:UIControlState() )},
            completion:{(finished:Bool)->() in self.navigationController?.popViewController(animated: true)
                Thread.sleep(forTimeInterval: 1.2)
        })
        
       // self.navigationController?.popViewControllerAnimated(true)
    }
  
    @IBAction func doneDidClick(){
        if configSet != nil {
            self.updateConfigSet(true)
        }else{
            rollbackRequired = false
            if textField.text != ""{
                self.createNewConfigSet()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func updateConfigSet(_ shouldPopView:Bool){
        // For "no updates, only renaming" policy, awitch the commented/uncommented rows below
        //configSet.setValue(self.textField.text, forKey: "configurationName")
        updateConfigSetObjectByCurrentState(configSet)
        
        do {
            try managedObjectContext.save()
            if(shouldPopView == true){
                self.navigationController?.popViewController(animated: true)
            }
        } catch let error as NSError{
            print ("could not save \(error)")
        }
    }
    
    func setPreviousConfigForCancelationCase(){
        let configSetEntity = NSEntityDescription.entity(forEntityName: "ConfigSet", in: self.managedObjectContext)
        prevConfigSet = NSManagedObject(entity: configSetEntity!, insertInto: nil)
        updateConfigSetObjectByCurrentState(prevConfigSet)
        prevConfigSet.setValue("previous", forKey:"configurationName")
    }
    func updateConfigSetObjectByCurrentState(_ configSetObject:NSManagedObject){
        UserSettings = UserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
        configSetObject.setValue(self.textField.text, forKey:"configurationName")


        for key in Constants.KEYS_ARRAY{
            let currentUserValue = UserSettings.value(forKey: key)
            let coreDataKey = "i" + String(key.characters.dropFirst())
            if(currentUserValue != nil){
                configSetObject.setValue(currentUserValue, forKey:coreDataKey)
            }
        }
    }
    
    func updateCurrentDeviceStateByCurrentConfigSet(){
        UserSettings = UserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        for key in Constants.KEYS_ARRAY{
            var currentConfigValue = configSet.value(forKey: key)
            if(currentConfigValue == nil)&&(key == KEY_ISSIE_KEYBOARD_LANGUAGES){
                currentConfigValue = MasterViewController.getPreferredLanguage()
            }
                UserSettings.setValue(currentConfigValue, forKey:key)
        }
        do{
            try managedObjectContext.save()
            UserSettings.synchronize()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    func createNewConfigSet(){
        let configSetEntity = NSEntityDescription.entity(forEntityName: "ConfigSet", in: self.managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertInto: self.managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        updateConfigSetObjectByCurrentState(configSetObject)
        do{
        try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    
    func createPredefinedConfigSets(){
        let configSetEntity = NSEntityDescription.entity(forEntityName: "ConfigSet", in: self.managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertInto: self.managedObjectContext)
        configSetObject.setValue(self.textField.text, forKey:"configurationName")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
