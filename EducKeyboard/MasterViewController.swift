//
//  MasterViewController.swift
//  IssieKeyboard
//
//  Created by Sasson, Kobi on 3/17/15.
//  Copyright (c) 2015 Sasson, Kobi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController	 {
    static let groupName = "group.com.issieshapiro.Issieboard"
    var detailViewController: DetailViewController? = nil
    var loadSaveViewController: ConfigSetsTableViewController? = nil
    var middleSwitchView:UISwitch? = nil
    let preferedLanguage  = MasterViewController.getPreferredLanguage()
    
    //var cellMiddleTextColor:UITableViewCell? = nil
   // var cellMiddleKeyColor:UITableViewCell? = nil
    
    let colorRowButtonImage =   UIImage(named: "paint-brush12.png")
    let colorRowButtonImageInverted =  MasterViewController.invertedImage(image: UIImage(named: "paint-brush12.png")!)
    let resetButtonImage =   UIImage(named: "reset-icon3.png")
    let languagesButtonImage =  UIImage(named: "earth-icon.png")
    let keysOrderButtonImage =  UIImage(named: "keys-order.png")
    let templatesButtonImage =  UIImage(named: "templates.png")
    var mapInfoToInfoButton:[UIButton:UIAlertController] = [:]
    
    let indexOfSectionMain          = 0
    let indexOfSectionMainColor     = 1
    let indexOfSectionAdditionals   = 2
    let indexOfSectionRowsColumns   = 3
    let indexOfSectionRight         = 4
    let indexOfSectionMiddle        = 5
    let indexOfSectionLeft          = 6
    let indexOfSectionVisibleKeys   = 7
    let indexOfSectionSpecialKeys   = 8
    let indexOfSectionTemplates     = 9
    
    //var colorCirclesDictionary: [IndexPath: UIButton] = [:]
    
    var data = [
        ConfigSection(title: wrapWithLocale(TITLE_MAIN_SETTINGS) ,
            items: [
                ConfigItem(key:KEY_ISSIE_KEYBOARD_RESET ,title: wrapWithLocale(TITLE_KEYBOARD_RESET) ,
                    defaultValue: UIColor.red,type: ConfigItemType.reset),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_LANGUAGES ,title: wrapWithLocale(TITLE_KEYBOARD_LANGUAGES) ,
                    defaultValue:  MasterViewController.getPreferredLanguage() as AnyObject?,type: ConfigItemType.language),
        ConfigItem(key:KEY_ISSIE_KEYBOARD_LANGUAGES,title:wrapWithLocale(TITLE_KEYBOARD_KEYS_ORDER),
                   defaultValue: MasterViewController.getPreferredLanguage() as AnyObject?,type: ConfigItemType.picker)]),

        ConfigSection(title: "" ,
                      items: [
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_BACKGROUND_COLOR ,title: wrapWithLocale(TITLE_KEYBOARD_BACKGROUND) ,
                                   defaultValue: UIColor.lightGray,type: ConfigItemType.color),
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_KEYS_COLOR,title: wrapWithLocale(TITLE_COLOR_OF_KEYS),
                                   defaultValue: UIColor.yellow,type: ConfigItemType.color),
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                                   defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
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
        ]),
        
        ConfigSection(title: "" ,
                      items: [
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN,title:wrapWithLocale(TITLE_COLS_VS_ROWS),
                                   defaultValue: "By Rows" as AnyObject?,type: ConfigItemType.picker)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_UPPER_RIGHT) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS),
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT),
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_MIDDLE) ,
            items: [
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT),
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_LOWER_LEFT) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_VISIBLE_KEYS),
                      items: [
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_VISIBLE_KEYS,title:wrapWithLocale(TITLE_SPECIAL_KEYS),
                                   defaultValue: "" as AnyObject?,type: ConfigItemType.string)]),
        
        ConfigSection(title: wrapWithLocale(TITLE_SPECIAL_KEYS_DEF) ,
            items: [ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT,title:wrapWithLocale(TITLE_SPECIAL_KEYS) ,
                defaultValue: "" as AnyObject?,type: ConfigItemType.string),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_KEYS) ,
                    defaultValue: UIColor.yellow,type: ConfigItemType.color),
                ConfigItem(key:KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT_COLOR,title:wrapWithLocale(TITLE_COLOR_OF_TEXT) ,
                    defaultValue: UIColor.blue,type: ConfigItemType.color)]),
        ConfigSection(title: "" ,
                      items: [
                        //    ConfigItem(key:KEY_ISSIE_KEYBOARD_TEMPLATES,title:wrapWithLocale(TITLE_TEMPLATE_SELECTION) ,
                        //    defaultValue: "My Configuration" , type: ConfigItemType.Templates),
                        ConfigItem(key:KEY_ISSIE_KEYBOARD_SAVE_LOAD,title:wrapWithLocale(TITLE_TEMPLATE) ,
                                   defaultValue: UIColor.cyan,    type: ConfigItemType.color)
            ])
    ]
    
    func getData() -> [ConfigSection]
    {
        return data
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
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //InitTemplates.ifNeededSetToDefault()
        InitTemplates.loadDefaultTemplates()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDisabledMiddleCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isIPad()){
            middleSwitchView?.isHidden = DetailViewController.isCurrentlyOnRows()
        }
    }
    
    @objc func resetSwitchAndAlertAboutRowsState(){
        middleSwitchView?.setOn(true, animated: true)
        let alertTitle = wrapWithLocale(TITLE_PLEASE_SET_COL_MODE)
        let alertDescription = wrapWithLocale(TITLE_PLEASE_SET_COL_MODE_DESC)
        let alertView = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: wrapWithLocale(TITLE_OK), style: UIAlertAction.Style.default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    @objc func createAlertInfoAboutAction(sender:UIButton, indexPath:IndexPath){
            let object = data[indexPath.section].items[indexPath.row] as ConfigItem
            let alertTitle = object.title
            let alertDescription = getInfoTextByIndexPath(indexPath: indexPath)
            let alertView = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: wrapWithLocale(TITLE_OK), style: UIAlertAction.Style.default, handler: nil))
            mapInfoToInfoButton[sender] = alertView
        }
    
    @objc func popAlertInfoAboutAction(sender:UIButton){
        let alertView = mapInfoToInfoButton[sender]
        present(alertView!, animated: true, completion: nil)
    }
        
        @objc func getInfoTextByIndexPath(indexPath:IndexPath)->String{
            var text = ""
            switch indexPath.section {
            case indexOfSectionVisibleKeys:
                text = wrapWithLocale(TITLE_INFO_VISIBLE_KEYS)
            case indexOfSectionSpecialKeys:
                text = wrapWithLocale(TITLE_INFO_SPECIAL_KEYS)
            case indexOfSectionRowsColumns:
                text = wrapWithLocale(TITLE_INFO_ROWS_COLS)
            default:
                wrapWithLocale(TITLE_INFO_ROWS_COLS)
            }
            return text
        }
    
    @objc func switchStateDidChange(_ sender:UISwitch){
        if(DetailViewController.isCurrentlyOnRows()){
            //We shouldn't get here anymore, row hide the switch
           resetSwitchAndAlertAboutRowsState()
        }
        else {
            if(!isIPad()){
                DetailViewController.switchMiddleState()
                self.setupDisabledMiddleCells()
            }
            else {
                let viewControllers = self.splitViewController?.viewControllers
                let currentDetailViewController = ((viewControllers![1] as! UINavigationController).viewControllers[0] as! DetailViewController)
                let isKeyboardOn = currentDetailViewController.showHideKeyboard.title(for: currentDetailViewController.showHideKeyboard.state) == wrapWithLocale(TITLE_HIDE_KEYBOARD)
                if(isKeyboardOn) {
                    currentDetailViewController.TapRecognize(sender)
                    DispatchQueue.main.asyncAfter(deadline: .now() + currentDetailViewController.DURATION_OF_KEYBOARD_ANIMATION, execute: {
                             DetailViewController.switchMiddleState()
                                            self.setupDisabledMiddleCells()
                    })
                }
                else {
                    DetailViewController.switchMiddleState()
                    self.setupDisabledMiddleCells()
                }
            }
        }
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
                    //controller.performSegue(withIdentifier: "loadSaveDetail", sender: self)
                    
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
        let currentTitle = data[section].title
        if(section == indexOfSectionRight || section == indexOfSectionLeft){
            let isSections = DetailViewController.isSections()
            if let index = currentTitle.range(of: "-")?.lowerBound {
                let nextIndex = currentTitle.index(index, offsetBy: 1)
                let substring = isSections ? currentTitle.prefix(upTo: index) : currentTitle.suffix(from: nextIndex)
                    return String(substring)
            
            }

        }
        return data[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        let section = data[indexPath.section]
        let items = section.items;
        let item: ConfigItem = items[indexPath.row]
          
        cell.textLabel!.text = item.title
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        if(indexPath.section == indexOfSectionMiddle && (indexPath.row == 0 || indexPath.row == 1)){
            setupStateOfMiddleCell(cell: cell)
            if(!cell.isUserInteractionEnabled){
                return cell
            }
        } else {
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textColor = UIColor.black
        }
        if let foundView = cell.viewWithTag(123) {
            foundView.removeFromSuperview()
        }
        //var currentButton = colorCirclesDictionary[indexPath]
        if (isCellDefinesColor(indexPath: indexPath)){
           // if(currentButton == nil) {
            addButtonAtCell(cell: cell, color: getColorForCell(indexPath: indexPath),indexPath: indexPath)
          //  }
        }
        else {
            if(isCellDefinesIconAccessory(indexPath: indexPath)){
                addButtonAtCell(cell: cell, color: UIColor.white, indexPath: indexPath)
            }
        }
//        else{
//            if(currentButton != nil){
//                currentButton?.removeFromSuperview()
//                currentButton = nil
//            }
        //}
        return cell
    }
    
    func isCellDefinesIconAccessory(indexPath: IndexPath)->Bool{
        return (indexPath.section == indexOfSectionMain) || (indexPath.section == indexOfSectionTemplates) || isInfoButtonCell(indexPath: indexPath)
    }
    
    func getColorRelatedSectionIndexes()->[Int]{
        return [indexOfSectionMainColor,indexOfSectionAdditionals, indexOfSectionRight, indexOfSectionMiddle, indexOfSectionLeft]
    }
    
    func isCellDefinesColor(indexPath: IndexPath)->Bool{
        let arrayOfColorRelatedSections = getColorRelatedSectionIndexes()
        if(arrayOfColorRelatedSections.contains(indexPath.section)) {
            return true
        }
        else{
            if(indexPath.section == indexOfSectionSpecialKeys && (indexPath.row == 1 || indexPath.row == 2)){
            return true
            }
        }
        return false
    }
    
    func getColorForCell(indexPath: IndexPath)->UIColor{
        let value = data[indexPath.section].items[indexPath.row].value
        return value as! UIColor
    }
    
    func reloadSelectedCell(){
        let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow
        if(indexPathForSelectedRow == nil){
            return
        }
        if(indexPathForSelectedRow!.section == indexOfSectionMain || indexPathForSelectedRow!.section == indexOfSectionTemplates){
            self.tableView.reloadSections(IndexSet(getColorRelatedSectionIndexes()), with: .automatic)
            self.tableView.reloadRows(at: [
            IndexPath(row: 1, section: indexOfSectionSpecialKeys),
            IndexPath(row: 2, section: indexOfSectionSpecialKeys)
            ], with: .automatic)
        } else {
            self.tableView.reloadRows(at: [indexPathForSelectedRow!], with: .automatic)
            if(indexPathForSelectedRow!.section == indexOfSectionMainColor){
                if(indexPathForSelectedRow!.row == 1){
                    self.tableView.reloadRows(at: [
                    IndexPath(row: 2, section: indexOfSectionMainColor),
                    IndexPath(row: 0, section: indexOfSectionLeft),
                    IndexPath(row: 0, section: indexOfSectionMiddle),
                    IndexPath(row: 0, section: indexOfSectionRight)
                    ], with: .automatic)
                }
                if(indexPathForSelectedRow!.row == 2){
                    self.tableView.reloadRows(at: [
                    IndexPath(row: 2, section: indexOfSectionMainColor),
                    IndexPath(row: 1, section: indexOfSectionLeft),
                    IndexPath(row: 1, section: indexOfSectionMiddle),
                    IndexPath(row: 1, section: indexOfSectionRight)
                    ], with: .automatic)
                }
                //self.tableView.reloadSections([3,4,5], with: .automatic)
            }
        }
        self.tableView.selectRow(at: indexPathForSelectedRow!, animated: false, scrollPosition: .none)
    }
    
    func isInfoButtonCell(indexPath:IndexPath)->Bool {
        return [indexOfSectionRowsColumns,indexOfSectionVisibleKeys].contains(indexPath.section) || (indexPath.section == indexOfSectionSpecialKeys && indexPath.row == 0)
    }
    
    func addButtonAtCell(cell:UITableViewCell, color:UIColor, indexPath:IndexPath){
        let buttonWidth = cell.frame.size.height - 20
        let cellWidth = cell.frame.size.width
        let xRightToLeft = buttonWidth - 10
        let xLeftToRight = cellWidth - buttonWidth - 10
        let xValue = isTypingDirectionRightToLeft() ? xRightToLeft : xLeftToRight
        let isInfoButton = isInfoButtonCell(indexPath: indexPath)
        let buttonFrame = CGRect(x: xValue, y: 10, width: buttonWidth, height: buttonWidth)

        let aButton = isInfoButton ? UIButton(type: .infoLight) : UIButton(frame: buttonFrame)
        
        aButton.alpha = 1.0
        aButton.tag = 123
        aButton.isUserInteractionEnabled = false
        if (indexPath.section == indexOfSectionMain && indexPath.row == 0){
            //aButton.setTitle("🔄", for: .normal)
            aButton.setImage(resetButtonImage, for: .normal)
            aButton.setImage(resetButtonImage, for: .selected)
        } else if (indexPath.section == indexOfSectionMain && indexPath.row == 1){
            //aButton.setTitle("🌎", for: .normal)
            aButton.setImage(languagesButtonImage, for: .normal)
            aButton.setImage(languagesButtonImage, for: .selected)
        } else if (indexPath.section == indexOfSectionMain && indexPath.row == 2){
            aButton.setImage(keysOrderButtonImage, for: .normal)
            aButton.setImage(keysOrderButtonImage, for: .selected)
            //return
        } else if (indexPath.section == indexOfSectionTemplates){
            let offset = isTypingDirectionRightToLeft() ? (-0.3) : 1
            let buttonFrame = CGRect(x: xValue - buttonWidth * CGFloat(offset), y: 10, width: buttonWidth*2, height: buttonWidth)
            aButton.frame = buttonFrame
            aButton.setImage(templatesButtonImage, for: .normal)
            aButton.setImage(templatesButtonImage, for: .selected)
            //aButton.setTitle("📂", for: .normal)
        } else if (isInfoButton){
            aButton.isUserInteractionEnabled = true
            aButton.frame = buttonFrame
            createAlertInfoAboutAction(sender: aButton, indexPath: indexPath)
            aButton.addTarget(self, action: #selector(popAlertInfoAboutAction(sender:)), for: UIControl.Event.touchUpInside)
            }
        else {
            aButton.layer.cornerRadius = buttonFrame.width/2
            aButton.backgroundColor = color
            
            aButton.layer.borderColor = UIColor.lightGray.cgColor
            aButton.layer.borderWidth = 1
//            if(color == UIColor.white) {
//                aButton.layer.borderColor = UIColor.lightGray.cgColor
//                aButton.layer.borderWidth = 1
//            }
//            else {
//                aButton.layer.borderWidth = 0
//            }
            
            //This is for brush icon, uncomment if needed
//            var buttonImage = colorRowButtonImage
//            if(MasterViewController.isColorDark(color: color)){
//                buttonImage = colorRowButtonImageInverted
//            }
//            aButton.setImage(buttonImage, for: .normal)
//            aButton.setImage(buttonImage, for: .selected)
        }
        cell.addSubview(aButton)
    }
    
        func addInfoButtonAtHeader(cell:UIView, indexPath:IndexPath){
            let buttonWidth = cell.frame.size.height - 20
            let cellWidth = cell.frame.size.width
            let xRightToLeft = buttonWidth - 10
            let xLeftToRight = cellWidth - buttonWidth - 10
            let xValue = isTypingDirectionRightToLeft() ? xRightToLeft : xLeftToRight
            let buttonFrame = CGRect(x: xValue, y: 10, width: buttonWidth, height: buttonWidth)
            
            let isInfoButton = isInfoButtonCell(indexPath: indexPath)
            let aButton = isInfoButton ? UIButton(type: .infoLight) : UIButton(frame: buttonFrame)
            
            aButton.alpha = 1.0
            aButton.tag = 123
            aButton.isUserInteractionEnabled = false
            
            aButton.isUserInteractionEnabled = true
            aButton.frame = buttonFrame
            createAlertInfoAboutAction(sender: aButton, indexPath: indexPath)
            aButton.addTarget(self, action: #selector(popAlertInfoAboutAction(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.addSubview(aButton)
        }
        
    
    static func invertedImage(image:UIImage) -> UIImage? {
        
        let img = CoreImage.CIImage(cgImage: image.cgImage!)
        
        let filter = CIFilter(name: "CIColorInvert")
        filter!.setDefaults()
        
        filter!.setValue(img, forKey: "inputImage")
        
        let context = CIContext(options:nil)
        
        let cgimg = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        return UIImage(cgImage: cgimg!)
    }
    static func isColorDark(color:UIColor)->Bool{
        var white: CGFloat = 0.0
        color.getWhite(&white, alpha: nil)
        return white < 0.85 // Don't use white background
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = super.tableView(tableView, viewForHeaderInSection: section)
        if(section == indexOfSectionMiddle) {
            //let headerHeight = tableView.sectionHeaderHeight
            let headerFrame = tableView.rectForHeader(inSection: indexOfSectionMiddle)
            //let switchHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
            let switchHeaderView = UIView.init(frame: headerFrame)
            let label = UILabel()
            let offset = isTypingDirectionRightToLeft() ? (-1) : 1
            label.frame = CGRect.init(x: CGFloat(16*offset), y: 0, width: switchHeaderView.frame.width, height: switchHeaderView.frame.height)
            label.text = wrapWithLocale(TITLE_MIDDLE)
            var middleHeaderFont = UIFont.TextStyle.body
            if #available(iOS 9.0, *) {
                if(!isIPad()) {
                    middleHeaderFont = UIFont.TextStyle.callout
                }
            }
            label.font = UIFont.preferredFont(forTextStyle: middleHeaderFont) // my custom iPad font
            label.textColor = UIColor.gray // my custom colour
            
            switchHeaderView.addSubview(label)
            addSwitchOnHeader(middleHeaderView: switchHeaderView)
            return switchHeaderView
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        //header.textLabel?.textColor = UIColor.red
        header.textLabel?.font = UIFont.systemFont(ofSize: 16)
        header.textLabel?.frame = header.frame
        //header.textLabel?.textAlignment = .center
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let heightForHeaderInSection = tableView.sectionHeaderHeight
//        if([indexOfSectionRight, indexOfSectionMiddle, indexOfSectionLeft].contains(section)) {
//            return heightForHeaderInSection * 3;
//        }
//        return heightForHeaderInSection * 3;
//    }
    
    func isTypingDirectionRightToLeft()->Bool{
        return (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft)
    }
    
    func addSwitchOnHeader(middleHeaderView:UIView) {
        setupDisabledMiddleCells()
        //let middleHeaderView = self.tableView.headerView(forSection: 4)
        let headerFrame = middleHeaderView.frame
        if (self.middleSwitchView != nil){
            self.middleSwitchView!.removeFromSuperview()
            self.middleSwitchView = nil
        }
        let yValue = (headerFrame.size.height - 31) / 2
        let xRightToLeft = headerFrame.size.width - 140
         let xLeftToRight = headerFrame.size.width - 220
         let xValue = isTypingDirectionRightToLeft() ? xRightToLeft : xLeftToRight
        self.middleSwitchView = UISwitch(frame: CGRect(x: xValue, y: yValue, width: 50, height: 31))
        self.middleSwitchView!.setOn(!DetailViewController.isTwoColorsKeyboard(), animated: false)
        self.middleSwitchView!.isHidden = DetailViewController.isCurrentlyOnRows()
        middleHeaderView.addSubview(self.middleSwitchView!)
        self.middleSwitchView!.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
    }
    
    func setupDisabledMiddleCells(){
        self.tableView.reloadSections([5], with: .automatic)
//        if(DetailViewController.isTwoColorsKeyboard()){
//            cellMiddleTextColor?.isUserInteractionEnabled = false
//            cellMiddleTextColor?.textLabel?.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
//            cellMiddleKeyColor?.isUserInteractionEnabled  = false
//            cellMiddleKeyColor?.textLabel?.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
//        }
//        else{
//            cellMiddleTextColor?.isUserInteractionEnabled = true
//            cellMiddleTextColor?.textLabel?.textColor = UIColor.black
//            cellMiddleKeyColor?.isUserInteractionEnabled  = true
//            cellMiddleKeyColor?.textLabel?.textColor = UIColor.black
//        }
    }
    
    func setupStateOfMiddleCell(cell:UITableViewCell?){
        if(DetailViewController.isTwoColorsKeyboard()){
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            if let foundView = cell!.viewWithTag(123) {
                foundView.removeFromSuperview()
            }
        }
        else{
            cell?.isUserInteractionEnabled = true
            cell?.textLabel?.textColor = UIColor.black
        }
    }
    
    @IBAction func backFromTemplates(_ segue: UIStoryboardSegue){
    
    }
    
    @IBAction func openInfoLink(){
        /*
         
         
         http://www.beitissie.org.il/tech/issieboard-%D7%9E%D7%94%D7%99%D7%95%D7%9D-%D7%92%D7%9D-%D7%91%D7%90%D7%A0%D7%92%D7%9C%D7%99%D7%AA/
         http://en.beitissie.org.il/tech/issieboard-virtual-keyboard-customizable-options-collaboration-beit-issie-shapiro-sap-labs-israel-2/

         */
        let link = wrapWithLocale("infoLink")
        if let url = NSURL(string: link){
            UIApplication.shared.openURL(url as URL)
        }
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
let TITLE_ENABLE_MIDDLE       = "EnableMiddle";

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
let TITLE_KEYBOARD_KEYS_ORDER  = "KeysOrder"
let TITLE_KEYBOARD_RESET_BUTTON   = "ResetToDefaultKeyboard"
let TITLE_KEYBOARD_RESET_DONE = "ResetToDefaultKeyboardDone"
let TITLE_KEYBOARD_LOADED     = "KeyboardSuccessfullyLoaded"
let KEY_ISSIE_KEYBOARD_SAVE_LOAD  = "KEY_ISSIE_KEYBOARD_SAVE_LOAD";

let TITLE_SHOW_KEYBOARD     = "ShowKeyboard"
let TITLE_HIDE_KEYBOARD     = "HideKeyboard"
let TITLE_CONFIGURATIONS    = "Configurations"

let TITLE_PLEASE_ENABLE_MIDDLE = "PleaseEnableMiddle"
let TITLE_RIGHT_LEFT = "RightLeft"
let TITLE_RIGHT_MIDDLE_LEFT = "RightMiddleLeft"
let TITLE_PLEASE_ENABLE_MIDDLE_DESC = "PleaseEnableMiddleDesc"
let TITLE_PLEASE_SET_COL_MODE = "PleaseSetToColumns"
let TITLE_PLEASE_SET_COL_MODE_DESC = "PleaseSetToColumnsDesc"
let TITLE_OK = "✔️"

let TITLE_ALPHABET = "KeysOrder"
let TITLE_ALPHABET_DESC = "KeysOrderDesc"
let TITLE_ALPHABET_STANDARD = "OrderStandard"
let TITLE_ALPHABET_ABC = "OrderABC"

let TITLE_INFO_VISIBLE_KEYS = "InfoVisibleKeys"
let TITLE_INFO_SPECIAL_KEYS = "InfoSpecialKeys"
let TITLE_INFO_ROWS_COLS = "InfoRowsCols"
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
