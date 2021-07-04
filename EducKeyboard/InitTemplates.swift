//
//  InitTemplates.swift
//  IssieBoard
//
//  Created by Even Sapir, Uriel on 4/3/16.
//  Copyright © 2016 sap. All rights reserved.
//

import UIKit
import CoreData


class InitTemplates: NSObject {

    static func loadPlists(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext

        for index in [1,2,3] {
        let bundlePath = Bundle.main.path(forResource: "DocumentationDefaultTemplates" + String(index), ofType: "plist")
        let templateDictionary1 = NSMutableDictionary(contentsOfFile: bundlePath!)
        
        
        var fullArray = Constants.KEYS_ARRAY
        fullArray.append("configurationName")
        
        let configSetEntity = NSEntityDescription.entity(forEntityName: "ConfigSet", in: managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertInto: managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        for key in fullArray{
            let currentValue = templateDictionary1?.value(forKey: key)
            var coreDataKey = "i" + String(key.characters.dropFirst())
            if(key == "configurationName")
            {
                coreDataKey = key
            }
            if(currentValue != nil){
                configSetObject.setValue(currentValue, forKey:coreDataKey)
                if(index==1){
                    UserSettings.setValue(currentValue, forKey:key)
                }
            }
        }
            do{
                try managedObjectContext.save()
                UserSettings.synchronize()
            }catch let error as NSError{
                print("could not save configurtion set \(error.description)")
            }
        }
        
        
    }

    static func ifNeededSetToDefault(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        let cString: String? = UserSettings.string(forKey: KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR)
        if(cString == nil){
            resetToDefaultTemplate()
        }
    }
    static func resetToDefaultTemplate(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
            let bundlePath = Bundle.main.path(forResource: "DocumentationDefaultTemplates1", ofType: "plist")
            let templateDictionary1 = NSMutableDictionary(contentsOfFile: bundlePath!)
            
            
            var fullArray = Constants.KEYS_ARRAY
            fullArray.append("configurationName")

            //configSetObject.setValue(self.textField.text, forKey:"configurationName")
            for key in fullArray{
                let currentValue = templateDictionary1?.value(forKey: key)
                if(currentValue != nil){
                    UserSettings.setValue(currentValue, forKey:key)
                }
            }
            UserSettings.synchronize()
    }

    
    
    static func createNewInitIndicator(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let initIndicatorEntity = NSEntityDescription.entity(forEntityName: "DidCreateDefaultTemplates", in: managedObjectContext)
        let initIndicatorObject = NSManagedObject(entity: initIndicatorEntity!, insertInto: managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        initIndicatorObject.setValue(true, forKey:"didInit")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    
    
    static func loadDefaultTemplates(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DidCreateDefaultTemplates")
        do{
            let didInitIndicator = try managedObjectContext.fetch(fetchRequest)
            if (didInitIndicator.count == 0){
                InitTemplates.loadPlists()
                createNewInitIndicator()
                
            }
            else{
              //  ifNeededSetToDefault()
            }
        } catch let error as NSError{
            print("could not fetch Indicator \(error), \(error.userInfo)")
        }
    }

}
