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
        let UserSettings = NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext

        for index in 1...3 {
        let bundlePath = NSBundle.mainBundle().pathForResource("DocumentationDefaultTemplates" + String(index), ofType: "plist")
        let templateDictionary1 = NSMutableDictionary(contentsOfFile: bundlePath!)
        
        
        var fullArray = Constants.KEYS_ARRAY
        fullArray.append("configurationName")
        
        let configSetEntity = NSEntityDescription.entityForName("ConfigSet", inManagedObjectContext: managedObjectContext)
        let configSetObject = NSManagedObject(entity: configSetEntity!, insertIntoManagedObjectContext: managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        for key in fullArray{
            let currentValue = templateDictionary1?.valueForKey(key)
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
        }
        do{
            try managedObjectContext.save()
            UserSettings.synchronize()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
        
    }

    static func resetToDefaultTemplate(){
        let UserSettings = NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
            let bundlePath = NSBundle.mainBundle().pathForResource("DocumentationDefaultTemplates1", ofType: "plist")
            let templateDictionary1 = NSMutableDictionary(contentsOfFile: bundlePath!)
            
            
            var fullArray = Constants.KEYS_ARRAY
            fullArray.append("configurationName")

            //configSetObject.setValue(self.textField.text, forKey:"configurationName")
            for key in fullArray{
                let currentValue = templateDictionary1?.valueForKey(key)
                if(currentValue != nil){
                    UserSettings.setValue(currentValue, forKey:key)
                }
            }
            UserSettings.synchronize()
    }

    
    
    static func createNewInitIndicator(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let initIndicatorEntity = NSEntityDescription.entityForName("DidCreateDefaultTemplates", inManagedObjectContext: managedObjectContext)
        let initIndicatorObject = NSManagedObject(entity: initIndicatorEntity!, insertIntoManagedObjectContext: managedObjectContext)
        //configSetObject.setValue(self.textField.text, forKey:"configurationName")
        initIndicatorObject.setValue(true, forKey:"didInit")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save configurtion set \(error.description)")
        }
    }
    
    
    static func loadDefaultTemplates(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "DidCreateDefaultTemplates")
        do{
            let didInitIndicator = try managedObjectContext.executeFetchRequest(fetchRequest)
            if (didInitIndicator.count == 0){
                InitTemplates.loadPlists()
                createNewInitIndicator()
                
            }
        } catch let error as NSError{
            print("could not fetch Indicator \(error), \(error.userInfo)")
        }
    }

}
