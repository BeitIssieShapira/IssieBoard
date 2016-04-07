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
    var UserSettings: NSUserDefaults!
    var updateCellDelegate:UpdateCellsDelegate!
    
    @IBOutlet weak var loadKeyboardButton: UIButton!
    @IBOutlet weak var textField: UITextField!    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.becomeFirstResponder()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        if configSet != nil {
            self.textField.text = configSet.valueForKey("configurationName") as? String
            let titleString = String(format: "%@", self.textField.text!)
            self.title = titleString
            self.loadKeyboardButton.hidden = false
            
        } else{
            self.title = wrapWithLocale(TITLE_NEW_KEYBOARD)
            self.loadKeyboardButton.hidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadButtonClicked(sender: UIButton) {
        configSet.setValue(self.textField.text, forKey: "configurationName")
        updateCurrentDeviceStateByCurrentConfigSet();
        updateCellDelegate.updateCheckedCell()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
  
    @IBAction func doneDidClick(){
        if configSet != nil {
            self.updateConfigSet(true)
        }else{
            if textField.text != ""{
                self.createNewConfigSet()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    func updateConfigSet(shouldPopView:Bool){
        // For "no updates, only renaming" policy, awitch the commented/uncommented rows below
        //configSet.setValue(self.textField.text, forKey: "configurationName")
        updateConfigSetObjectByCurrentState(configSet)
        
        do {
            try managedObjectContext.save()
            if(shouldPopView == true){
                self.navigationController?.popViewControllerAnimated(true)
            }
        } catch let error as NSError{
            print ("could not save \(error)")
        }
    }
    
    func updateConfigSetObjectByCurrentState(configSetObject:NSManagedObject){
        UserSettings = NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
        configSetObject.setValue(self.textField.text, forKey:"configurationName")


        for key in Constants.KEYS_ARRAY{
            let currentUserValue = UserSettings.valueForKey(key)
            let coreDataKey = "i" + String(key.characters.dropFirst())
            if(currentUserValue != nil){
                configSetObject.setValue(currentUserValue, forKey:coreDataKey)
            }
        }
    }
    
    func updateCurrentDeviceStateByCurrentConfigSet(){
        UserSettings = NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        for key in Constants.KEYS_ARRAY{
            let currentConfigValue = configSet.valueForKey(key) as! String
            //if(currentConfigValue != nil){
                UserSettings.setValue(currentConfigValue, forKey:key)
            //}
        }
        do{
            try managedObjectContext.save()
            UserSettings.synchronize()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    func createNewConfigSet(){
        let configSetEntity = NSEntityDescription.entityForName("ConfigSet", inManagedObjectContext: self.managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        updateConfigSetObjectByCurrentState(configSetObject)
        do{
        try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    
    func createPredefinedConfigSets(){
        let configSetEntity = NSEntityDescription.entityForName("ConfigSet", inManagedObjectContext: self.managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
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
