//
//  ConfigSetsTableViewController.swift
//  IssieBoard
//
//  Created by Even Sapir, Uriel on 3/15/16.
//  Copyright © 2016 sap. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateCellsDelegate{
    mutating func updateCheckedCell()
}

class ConfigSetsTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UpdateCellsDelegate{
    var configs:[NSManagedObject]!
    var managedObjectContext: NSManagedObjectContext!
    var currentCell:UITableViewCell!
    var previousCell:UITableViewCell!
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.title = wrapWithLocale(TITLE_SAVE_LOAD)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isIPad()){
            backBarButtonItem.title = ""
        }else{
            backBarButtonItem.title = wrapWithLocale(TITLE_CONFIGURATIONS)
        }
        fetchConfigs()
    }
    override func viewDidDisappear(_ animated: Bool) {
        //self.navigationController?.popToRootViewControllerAnimated(true)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.navigationItem.setHidesBackButton(false, animated: false)
      //  self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Master", style: UIBarButtonItemStyle.Done, target: self, action: "backButtonClicked"), animated: true)
        
    }
    func backButtonClicked(){
        //self.navigationItem.popViewControllerAnimated(false)
        //self.navigationController?.popViewControllerAnimated
        //self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated:true)
        //var prev = self.navigationController?.popViewControllerAnimated(true)
        //prev!.navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.viewControllers.
        self.navigationController?.popToRootViewController(animated: true)
       // self.splitViewController?.presentViewController((self.navigationController?.viewControllers[0])!, animated: false, completion: nil)
    }
    func fetchConfigs(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConfigSet")
        do{
            let configObject = try managedObjectContext.fetch(fetchRequest)
            self.configs = configObject as! [NSManagedObject]

        } catch let error as NSError{
            print("could not fetch configs \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let confSet = self.fetchedResultsController.objectAtIndexPath(indexPath) as! ConfigSet
        // Populate cell from the NSManagedObject instance
        print("Object for configuration: \(confSet)")
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadSaveCell", for: indexPath) 
        // Set up the cell
        let configSet = configs[indexPath.row]
        cell.textLabel?.text = EditConfigViewController.getTranslateConfigurationName(configSet: configSet)//configSet.value(forKey: "configurationName") as? String
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self.fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count
        
        //let sections = self.fetchedResultsController.sections as! [NSFetchedResultsSectionInfo ]
       // let sectionInfo = sections[section]
       // return sectionInfo.numberOfObjects
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (0...2 ~= indexPath.row){
            return false
        }
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let configSet = self.configs[indexPath.row]
            self.managedObjectContext.delete(configSet)
            self.configs.remove(at: indexPath.row)
            

            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
            try self.managedObjectContext.save()
            } catch let error as NSError{
                print("Could not delete object: \(error). \(error.localizedDescription)")
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let configSet = self.configs[indexPath.row]
        currentCell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "showEditScreen", sender: configSet)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditScreen" {
        let editConfigViewController = segue.destination as! EditConfigViewController
            editConfigViewController.configSet = sender as? NSManagedObject
            editConfigViewController.updateCellDelegate = self
            //if(currentCell != nil){
            //    editConfigViewController.currentCell = self.currentCell
            // }
        }
    }
    
    func updateCheckedCell(){
        if(currentCell != nil){
            currentCell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        if(previousCell != nil){
            previousCell.accessoryType = UITableViewCellAccessoryType.none
        }
        previousCell = currentCell
    }
    /*
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
*/
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
