//
//  DetailViewController.swift
//  IssieKeyboard
//
//  Created by Sasson, Kobi on 3/17/15.
//  Copyright (c) 2015 Sasson, Kobi. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData



class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var colorPalette: UIView!
    @IBOutlet var ToggleKeyboard: UITextField!
    @IBOutlet var PreviewKeyboard: UIButton!
    @IBOutlet var RowColPicker: UISegmentedControl!
    @IBOutlet var TemplatePicker: UIStepper!
    @IBOutlet var HideButton: UIButton!
    @IBOutlet var itemValue: UITextView!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var showHideKeyboard: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var languagesView: UIView!
    
    //var configSet: NSManagedObject!
    let langKeys = ["EN","HE","BOTH","AR","AR_EN","AR_HE"]
    let languageOrderIndicator = "@"
    var selectedLanguageOrder = ""
    var onTheWayToTemplates:Bool        = false
    var didNowPerformShowHideKeyboard   = false
    var didSetupLanguageButtons         = false
    var keyboardIsAnimating             = false //26.6.2021 for solving visible keys and template race conditions
    //var KEYBOARD_STATE_DURING_UPDATE = 0
    var nextWidth:CGFloat    = 0.0
    let MAX_COLORS_PER_ROW   = 10
    let IPAD_BUTTON_SIZE :CGFloat    = 100
    let IPAD_PRO_BUTTON_SIZE:CGFloat = 140
    let IPHONE_BUTTON_SIZE:CGFloat   = 60
    let DURATION_OF_KEYBOARD_ANIMATION = 0.6 //Found a value which solves the race but not too slow
    let enKeys = "QWERTYUIOPASDFGHJKLZXCVBNM"
    let ALL_VISIBLE_KEYS = "אבגדהוזחטיכלמנסעןפצקרשתםףךץ1234567890.,?!'•_\\|~<>$€£[]{}#%^*+=.,?!'\"-/:;()₪&@QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmضصقفغعهخحجشسيبلاتنمكظطذدزروةث١؟٢٣٤٥٦v٨٩٠"
    let ARRAY_OF_COLORS = [
        UIColor.purple,
        "9C07E1",
        "C800FF",
        "F28DFB",
        "FF00BB",
        "8980DE",
        UIColor.blue,
        "6000FF",
        "0080FF",
        "00DDFF",
        "8DEAFB",
        "8DFBCD",
        "225E16",
        "11D950",
        UIColor.green,
        UIColor.yellow,
        "EDED21",
        "FF6200",
        "FF9500",
        UIColor.red,
        "C70A0A",
        UIColor.brown,
        "C27946",
        "F5C28C",
        "DE808D",
        UIColor.white,
        UIColor.lightGray,
        UIColor.gray,
        UIColor.darkGray,
        UIColor.black
    ] as [Any]
    
    var configItem: ConfigItem? {
        didSet {
            self.configureView()
        }
    }

    
    @IBAction func TapRecognize(_ sender: AnyObject) {
        if(isTypeKeysScenario()){
            return
        }
        if(ToggleKeyboard.isFirstResponder||itemValue.isFirstResponder){
            showHideTapped(showHideKeyboard)
        }
    }

    static func getPreviousCurrentMode()->Int{
        if let savedValue = UserDefaults(suiteName: MasterViewController.groupName)!.string(forKey: "currentMode") {
            print(savedValue)
            return Int(savedValue)!
        }
        else{
            return 0
        }
    }
    
    func languageButtonVisualSetup(_ sender: UIButton) {
        let unselectedColor =  UIColor.init(red: 0.921431005
            , green: 0.921452641, blue: 0.921441018, alpha: 1.0)
        let selectedColor = UIColor.init(red: 0.450857997
            , green: 0.988297522, blue: 0.83763045, alpha: 1.0)
        
        self.languagesView.subviews.forEach {
            let button = $0 as! UIButton
            button.isSelected = false
            button.backgroundColor = unselectedColor
            button.tintColor = unselectedColor
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.setTitleColor(UIColor.black, for: UIControl.State.selected)
            button.titleShadowColor(for: UIControl.State.selected)
            button.layer.borderWidth = 5
            button.layer.borderColor = unselectedColor.cgColor
        }
        
        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {
            sender.isSelected = true;
            sender.backgroundColor = selectedColor
            sender.tintColor = selectedColor
        },
                          completion:nil
        )
    }
    
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        let unselectedColor =  UIColor.init(red: 0.921431005
            , green: 0.921452641, blue: 0.921441018, alpha: 1.0)
        let selectedColor = UIColor.init(red: 0.450857997
            , green: 0.988297522, blue: 0.83763045, alpha: 1.0)
        //Swift4
        //let unselectedColor = UIColor.init(colorLiteralRed: 0.921431005
        //    , green: 0.921452641, blue: 0.921441018, alpha: 1.0)
        //let selectedColor = UIColor.init(colorLiteralRed: 0.450857997
        //    , green: 0.988297522, blue: 0.83763045, alpha: 1.0)
     /*   let unselectedColor =  UIColor.init(red: 0.921431005
            , green: 0.921452641, blue: 0.921441018, alpha: 1.0)
        let selectedColor = UIColor.init(red: 0.450857997
            , green: 0.988297522, blue: 0.83763045, alpha: 1.0)
        
        self.languagesView.subviews.forEach {
            let button = $0 as! UIButton
            button.isSelected = false
            button.backgroundColor = unselectedColor
            button.tintColor = unselectedColor
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.setTitleColor(UIColor.black, for: UIControl.State.selected)
            button.titleShadowColor(for: UIControl.State.selected)
            button.layer.borderWidth = 5
            button.layer.borderColor = unselectedColor.cgColor
            //let currentLangKey = langKeys[button.tag-1]
            //button.setTitle(wrapWithLocale(currentLangKey) , for: UIControlState.normal)
        }*/
        languageButtonVisualSetup(sender)

        /*UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {
            sender.isSelected = true;
            sender.backgroundColor = selectedColor
            sender.tintColor = selectedColor
        },
                          completion:nil
        )*/
        if(didSetupLanguageButtons==true){
            /*let setupClosure = {
                let languageKey = sender.tag-1
                if let item: ConfigItem = self.configItem {
                    self.resetVisibleKeys()
                    item.value = (self.langKeys[languageKey] + self.selectedLanguageOrder) as AnyObject?
                }
            }*/
            
//            if (selectedLanguageOrder == self.languageOrderIndicator){
//            selectedLanguageOrder =
//            }
        }
        let languageKey = sender.tag-1
            if let item: ConfigItem = self.configItem {
                resetVisibleKeys()
                item.value = langKeys[languageKey] as AnyObject?
                //setLanguageOrderPopUpReturnSelection(item)
            }
    }
    
    func setLanguageOrderPopUpReturnSelection(_ item: ConfigItem){
        let alert = UIAlertController(title: wrapWithLocale(TITLE_ALPHABET), message: TITLE_ALPHABET_DESC, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: TITLE_ALPHABET_STANDARD, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: TITLE_ALPHABET_ABC, style: .cancel, handler: { action in item.value  = (item.value as! String) + self.languageOrderIndicator as AnyObject}))
        self.present(alert, animated: true)
    }
    
    func setLanguageOrderBySegmentedValue(_ sender: UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){//Standard
            configItem?.value = configItem!.value?.replacingOccurrences(of: self.languageOrderIndicator, with: "") as AnyObject
        }
        else {//ABC
            if(!isCurrentKeysOrderByABC()) {
                configItem?.value  = (configItem?.value as! String) + self.languageOrderIndicator as AnyObject
            }
        }
    }
    
    func isCurrentKeysOrderByABC()->Bool {
        return (configItem!.value?.hasSuffix(self.languageOrderIndicator))!
    }
    func setupKeysOrderPicker(){
        let initialValue = isCurrentKeysOrderByABC() ? 1 : 0
        RowColPicker.selectedSegmentIndex = initialValue
        RowColPicker.setTitle(wrapWithLocale(TITLE_ALPHABET_STANDARD), forSegmentAt: 0)
        RowColPicker.setTitle(wrapWithLocale(TITLE_ALPHABET_ABC), forSegmentAt: 1)
    }
    
    @IBAction func showHideTapped(_ sender: UIButton) {
        //26.6.2021 for solving visible keys and template race
//        if (keyboardIsAnimating){
//            return
//        }
        var title:String
        let currentFirstResponder = (isTypeKeysScenario()) ?
            itemValue : ToggleKeyboard
        didNowPerformShowHideKeyboard = true
        if(currentFirstResponder!.isFirstResponder){
            
            title = wrapWithLocale(TITLE_SHOW_KEYBOARD)
            currentFirstResponder!.resignFirstResponder()
            didNowPerformShowHideKeyboard = false
        }
        else{
            title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
            currentFirstResponder!.becomeFirstResponder()
        }
        UIView.transition(with: sender, duration: DURATION_OF_KEYBOARD_ANIMATION, options: [.transitionFlipFromTop], animations: {sender.setTitle(title, for:UIControl.State() )},
            completion:nil
        )
    }
    
    @IBAction func ChangedMode(_ sender: UISegmentedControl) {
        
        let isKeyboardOn = self.showHideKeyboard.title(for: self.showHideKeyboard.state) == wrapWithLocale(TITLE_HIDE_KEYBOARD)
        if(isKeyboardOn) {
            TapRecognize(sender)
                DispatchQueue.main.asyncAfter(deadline: .now() + DURATION_OF_KEYBOARD_ANIMATION, execute: {
                    self.ChangedMode(sender)
            })
        }
        else {
            //TapRecognize(sender)//changed at 7.2020, if stable...
            if(wrapWithLocale(TITLE_KEYBOARD_KEYS_ORDER) == configItem?.title){
                setLanguageOrderBySegmentedValue(sender)
            }
            else {
                let values = ["By Rows","By Sections"]
                //"By Rows"/"By Sections" switch
                let newValue = values[sender.selectedSegmentIndex]
                configItem?.value = newValue as AnyObject?
                //DetailViewController.switchMiddleState();
                let navController = self.splitViewController?.viewControllers.first as? UINavigationController
                let masterView = navController?.topViewController as? MasterViewController
                masterView?.tableView.reloadSections([4,6], with: .automatic)
                if(newValue == "By Rows"){//We force the switch to be enabled
                    //masterView?.middleSwitchView!.setOn(true, animated: false)
                     let switchView = masterView?.middleSwitchView
                    if (switchView != nil){
                        setIsHiddenViewAnimated(view: switchView!, isHidden: true)
                    }
                    
                    if(DetailViewController.isTwoColorsKeyboard()){
                        DetailViewController.switchMiddleState()
                        masterView?.setupDisabledMiddleCells()
                    }
                }
                else {
                    let switchView = masterView?.middleSwitchView
                    if (switchView != nil){
                        setIsHiddenViewAnimated(view: switchView!, isHidden: false)
                    }
                }
            }
            showHideTapped(showHideKeyboard)
        }
    }
    
    func setIsHiddenViewAnimated(view:UIView, isHidden:Bool){
        UIView.animate(
            withDuration: 0.25,
            animations: {
                view.alpha = isHidden ? 0.0 : 1.0
        },
            completion: { isFinished in
                if isFinished {
                    view.isHidden = isHidden
                }
        }
        )
    }
    
    @IBAction func PreviewKeyboardClicked(_ sender: UIButton) {
        ToggleKeyboard.becomeFirstResponder()
    }
    
    @IBAction func ResetClicked(_ sender: UIButton) {
        let title = wrapWithLocale(TITLE_KEYBOARD_RESET_DONE)
        InitTemplates.resetToDefaultTemplate()
        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {sender.setTitle(title, for:UIControl.State() )},
            completion:nil
        )
        reloadMasterSelectedRow()
    }
    
    func setLanguageButtonsByCurrent(){
        let prevSelectedLang:String
        var selectedButton:UIButton? = nil
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let paddingX:CGFloat = 10
        let paddingY:CGFloat = 10
        let languagesFrame = self.view.frame
        let languagesWidth = languagesFrame.width - paddingX * 2
        let langagesHeight = (languagesFrame.height - paddingY*10 - navBarHeight!) / 6
        
        var buttonFrame = CGRect.init(x: paddingX, y: paddingY*3+navBarHeight!, width: languagesWidth, height: langagesHeight)
        
        if let item: ConfigItem = self.configItem {
             prevSelectedLang = item.value as! String // EN,HE,BOTH
        } else{
            prevSelectedLang = MasterViewController.getPreferredLanguage()
        }
        
        self.languagesView.subviews.forEach {
            let button = $0 as! UIButton
            let currentTag = button.tag
            let currentLangKey = langKeys[currentTag-1]
            
            if 1...6 ~= currentTag{
                button.setTitle(wrapWithLocale(currentLangKey) , for: UIControl.State.normal)
                button.setTitle(wrapWithLocale(currentLangKey) , for: UIControl.State.selected)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                if (currentLangKey == prevSelectedLang.replacingOccurrences(of: self.languageOrderIndicator, with: "")){
                    selectedButton = button
                }
                button.frame = buttonFrame
                buttonFrame.origin = CGPoint(x: buttonFrame.origin.x, y: buttonFrame.origin.y+paddingY + langagesHeight)
            }
        }
            //languageButtonTapped(selectedButton!)
        languageButtonVisualSetup(selectedButton!)
    }
    
    func isTypeKeysScenario()->Bool{
        if((self.configItem?.key == KEY_ISSIE_KEYBOARD_VISIBLE_KEYS) ||
            (self.configItem?.key == KEY_ISSIE_KEYBOARD_SPECIAL_KEYS_TEXT)){
                return true
        }
        else{
            return false
        }
    }
    func performSegue(){
        self.performSegue(withIdentifier: "loadSaveDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = (segue.destination as! ConfigSetsTableViewController)
    }
        
    func configureView() {
        
        if let toggle = self.ToggleKeyboard {
            toggle.isHidden = true
        }
        
        if let item: ConfigItem = self.configItem {
            if let valueField = self.itemValue {
                if let palette = self.colorPalette {
                    if let modePicker = self.RowColPicker {
                        let font = UIFont.systemFont(ofSize: 24)
                        self.RowColPicker.setTitleTextAttributes([NSAttributedString.Key(rawValue: convertFromNSAttributedStringKey(NSAttributedString.Key.font)): font], for: UIControl.State())
                        valueField.layer.borderWidth = 1.3
                        self.title = item.title
                        
                        switch item.type {
                        case .string:
                            languagesView.isHidden = true
                            valueField.isUserInteractionEnabled  = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            if(!isTypeKeysScenario()){
                                valueField.text = item.value as! String
                            }
                            else if(isTypeKeysScenario()){
                                if((item.value as! String) != ""){
                                    valueField.text = item.value as! String
                                }
                            }
                            
                            modePicker.isHidden = true
                            TemplatePicker.isHidden = true
                        case .color:
                            languagesView.isHidden = true
                            TemplatePicker.isHidden = true
                            palette.isHidden = false
                            scrollView.isHidden = false
                            valueField.isUserInteractionEnabled = false
                            valueField.backgroundColor = item.value as? UIColor
                            modePicker.isHidden = true
                            if(wrapWithLocale(TITLE_ENABLE_MIDDLE) == configItem?.title){
                                modePicker.isHidden = false
                                palette.isHidden = true
                                scrollView.isHidden = true
                                valueField.isUserInteractionEnabled = true
                                valueField.isHidden = true
                                RowColPicker.setTitle(wrapWithLocale(TITLE_RIGHT_LEFT), forSegmentAt: 0)
                                RowColPicker.setTitle(wrapWithLocale(TITLE_RIGHT_MIDDLE_LEFT), forSegmentAt: 1)
                                RowColPicker.selectedSegmentIndex = DetailViewController.isTwoColorsKeyboard() ? 0 : 1

                                showAlertMessage()
                            }
                            
                        case .picker:
                            languagesView.isHidden = true
                            TemplatePicker.isHidden = true
                            valueField.isUserInteractionEnabled = true
                            valueField.isHidden = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = false
                            
                            RowColPicker.selectedSegmentIndex = configItem?.value as! String == "By Rows" ? 0 : 1
                            if(configItem?.title == wrapWithLocale(TITLE_KEYBOARD_KEYS_ORDER)){
                                setupKeysOrderPicker()
                            }
                            //showAlertMessage() TODO: uncomment if we wan alert on sections/rows when middle disabled
                        case .fontPicker:
                            languagesView.isHidden = true
                            valueField.isUserInteractionEnabled = true
                            TemplatePicker.isHidden = true
                            valueField.isHidden = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = true
                        case .templates:
                            languagesView.isHidden = true
                            TemplatePicker.value = 0
                            valueField.isUserInteractionEnabled = false
                            TemplatePicker.isHidden = false
                            valueField.isHidden = false
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = true
                            showHideKeyboard.isHidden = true
                        case .reset:
                            languagesView.isHidden = true
                            TemplatePicker.value = 0
                            valueField.isUserInteractionEnabled = false
                            TemplatePicker.isHidden = true
                            valueField.isHidden = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = true
                            ToggleKeyboard.isHidden = true
                            PreviewKeyboard.isHidden = true
                            showHideKeyboard.isHidden = true
                            HideButton.isHidden = true
                            resetButton.isHidden = false
                            resetButton.setTitle(wrapWithLocale(TITLE_KEYBOARD_RESET_BUTTON) , for: UIControl.State())
                        case.language:
                            languagesView.isHidden = false
                            valueField.isUserInteractionEnabled = true
                            TemplatePicker.isHidden = true
                            valueField.isHidden = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = true
                            ToggleKeyboard.isHidden = true
                            PreviewKeyboard.isHidden = true
                            showHideKeyboard.isHidden = true
                            HideButton.isHidden = true
                            resetButton.isHidden = true
                            setLanguageButtonsByCurrent()
                            didSetupLanguageButtons = true
                        }
                    }
                }
            }
        }
        else
        {
            TemplatePicker.isHidden = true
            colorPalette.isHidden = true
            scrollView.isHidden = true
            itemValue.isHidden = true
            RowColPicker.isHidden = true
            showHideKeyboard.isHidden = true
        }
    }
    
    func AdditonalStyleEffects(){
        self.showHideKeyboard.layer.cornerRadius = 5
        self.itemValue.layer.cornerRadius = 15
        self.resetButton.layer.cornerRadius = 5
    }
    
    func updateColor(_ color: UIColor) {
        
        let isKeyboardOn = self.showHideKeyboard.title(for: self.showHideKeyboard.state) == wrapWithLocale(TITLE_HIDE_KEYBOARD)
        if(isKeyboardOn) {
            TapRecognize(color)
                DispatchQueue.main.asyncAfter(deadline: .now() + DURATION_OF_KEYBOARD_ANIMATION, execute: {
                    self.updateColor(color)
            })
        }
        else {
            if let valueField = self.itemValue {
                if let item: ConfigItem = self.configItem {
                    valueField.backgroundColor = color
                    item.value = color
                }
            }
            reloadMasterSelectedRow()
        }
        
    }
    
    func closeAndOpenKeyboard() {
        //let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //let textField = UITextField(frame: frame)
        //textField.becomeFirstResponder()
        if(ToggleKeyboard.isFirstResponder) {
            ToggleKeyboard.resignFirstResponder()
            ToggleKeyboard.becomeFirstResponder()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if (keyboardIsAnimating){
//            //26.6.2021 for solving visible keys and template race
//            return false
//        }
        if(textView == itemValue){
            if(didNowPerformShowHideKeyboard == false){
                let title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
                UIView.transition(with: self.showHideKeyboard, duration: DURATION_OF_KEYBOARD_ANIMATION, options: [.transitionFlipFromTop ], animations: {self.showHideKeyboard.setTitle(title, for:UIControl.State() )},
                    completion:nil)
            }
            ifEqualAllValuesDisplayEmptyString(textView)
        }
        didNowPerformShowHideKeyboard = false
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView){
        self.itemValue!.resignFirstResponder()
        self.ToggleKeyboard.resignFirstResponder()
        keyboardIsAnimating = true //26.6.2021 for solving visible keys and template race
        DispatchQueue.main.asyncAfter(deadline: .now() + DURATION_OF_KEYBOARD_ANIMATION, execute: {
                    if let detail: ConfigItem = self.configItem {
                if let valueField = self.itemValue {
                    
                    if(valueField.text.isEmptyOrWhiteSpace && self.configItem?.key == KEY_ISSIE_KEYBOARD_VISIBLE_KEYS)
                    {
                        detail.value = self.ALL_VISIBLE_KEYS as AnyObject?;
                    }
                    else
                    {
                        detail.value = valueField.text as AnyObject?
                       //handleVisibleKeysSaveBug(newValue: "yyy")
                    }
                }
                        self.keyboardIsAnimating = false
            }
        })
        
//        if let detail: ConfigItem = self.configItem {
//            if let valueField = self.itemValue {
//                
//                if(valueField.text.isEmptyOrWhiteSpace && configItem?.key == KEY_ISSIE_KEYBOARD_VISIBLE_KEYS)
//                {
//                    detail.value = ALL_VISIBLE_KEYS as AnyObject?;
//                }
//                else
//                {
//                    detail.value = valueField.text as AnyObject?
//                   //handleVisibleKeysSaveBug(newValue: "yyy")
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.AdditonalStyleEffects()
        self.scrollView.contentSize.width = 0
        if(isTypeKeysScenario()){
            itemValue.becomeFirstResponder()
        }
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification:NSNotification)
    {
        let title = wrapWithLocale(TITLE_SHOW_KEYBOARD)
        if (showHideKeyboard.currentTitle != title){
            UIView.transition(with: showHideKeyboard, duration: 0.3,
                options: [.transitionFlipFromTop ], animations:
                {self.showHideKeyboard.setTitle(title, for:UIControl.State() )},completion:nil)
        }
    }

    override func viewDidLayoutSubviews() {
        //if(KEYBOARD_STATE_DURING_UPDATE == 0){
        let newViewWidth = self.view.frame.width
        if(nextWidth != newViewWidth){
            self.nextWidth = self.view.frame.width
            self.initColorRainbow()
        }
        if(languagesView.isHidden == false){
            setLanguageButtonsByCurrent()
        }
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func displayColor(_ sender:UIButton){
        var r:CGFloat = 0,g:CGFloat = 0,b:CGFloat = 0
        var a:CGFloat = 0
        var h:CGFloat = 0,s:CGFloat = 0,l:CGFloat = 0
        let color = sender.backgroundColor!
        
        if color.getHue(&h, saturation: &s, brightness: &l, alpha: &a){
            if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                /*let colorText = NSString(format: "HSB: %4.2f,%4.2f,%4.2f RGB: %4.2f,%4.2f,%4.2f",
                    Float(h),Float(s),Float(b),Float(r),Float(g),Float(b))
                print("\(colorText)")*/
                
                self.updateColor(color)
            }
        }
        //updateCurrentKeyByColor(color)
        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: nil,
            completion:nil
        )
        //moved reloadMasterSelectedRow from here, 27.9.2020 todo, clean these comments when stable
        
    }
    
    func reloadMasterSelectedRow(){
        let viewControllersInSplit = self.splitViewController?.viewControllers
        let navController = viewControllersInSplit?.first as? UINavigationController
        let masterView = navController?.topViewController as? MasterViewController
        if(masterView != nil) {
            masterView?.reloadSelectedCell()
        }
        else {
            let iphonePortraitMasterView = navController?.viewControllers[0] as? MasterViewController
            iphonePortraitMasterView!.reloadSelectedCell()
        }
        
    }
    
    func initColorRainbow(){
       // self.colorPalette.subviews.forEach { $0.removeFromSuperview() }
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        let viewWidth:CGFloat    = nextWidth - scrollView.frame.origin.x
  
        let BUTTON_WIDTH =
        isIpadPro() ? IPAD_PRO_BUTTON_SIZE  : isIPad() ? IPAD_BUTTON_SIZE : IPHONE_BUTTON_SIZE
        let numOfButtonsInRow:Int = min(Int(floor((viewWidth) / BUTTON_WIDTH))-1,MAX_COLORS_PER_ROW)
        let buttonsWidth:Int = numOfButtonsInRow * Int(BUTTON_WIDTH)
        let offset:Int = (Int(viewWidth) - buttonsWidth) / 2
        

        var buttonFrame = CGRect(x: offset, y: 10, width: Int(BUTTON_WIDTH), height: Int(BUTTON_WIDTH))
        
        buttonFrame.origin.y    = makeClassicColorsButtons(buttonFrame,
                                  stringColorArray: ARRAY_OF_COLORS as! [NSObject],iterationNumber: 0)
        buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height*1.5
        scrollView.contentSize.height = buttonFrame.origin.y
    }
    
    func makeUIColorsButtons(_ buttonFrame:CGRect){
        
        var myButtonFrame = buttonFrame
        var colorsArray: [UIColor] = [UIColor.black, UIColor.darkGray,UIColor.gray,UIColor.lightGray, UIColor.white, UIColor.brown, UIColor.orange, UIColor.yellow,UIColor.blue, UIColor.purple, UIColor.green]
        //Second Row
        for i in 0..<11{
            let color = colorsArray[i]
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.white.cgColor
            aButton.layer.borderWidth = 1
            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    func makeClassicColorsButtons(_ buttonFrame:CGRect)->CGFloat{
        
        var myButtonFrame = buttonFrame
        var stringColorArray :[String] = ["C70A0A","FF00BB","C800FF","4400FF","0080FF","00DDFF","11D950","EDED21","FF9500","FF6200","C27946"]
        //FirstbRow
        for i in 0..<11{
            let color = hexStringToUIColor(stringColorArray[i])
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.white.cgColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControl.Event.touchUpInside)
        }
        return myButtonFrame.origin.y
    }
    func makeClassicColorsButtons(_ buttonFrame:CGRect, stringColorArray :[NSObject],iterationNumber:Int)->CGFloat{
        
        var myButtonFrame = buttonFrame
        let numberOfColors = stringColorArray.count
        let numOfButtonsInRow = min(Int(floor((nextWidth) / myButtonFrame.width))-1,numberOfColors,MAX_COLORS_PER_ROW)
        for i in 0..<numOfButtonsInRow {
            let color = (stringColorArray[i] is UIColor) ? stringColorArray[i] as! UIColor : hexStringToUIColor(stringColorArray[i] as! String)
            let aButton = UIButton(frame: myButtonFrame)
            
            aButton.layer.cornerRadius = buttonFrame.width/2
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.lightGray.cgColor
            aButton.layer.borderWidth = 1
            aButton.alpha = 0.0
            
            if let view = self.scrollView{
                view.addSubview(aButton)
                UIView.animate(withDuration: 0.15, delay: (Double(i)+Double(iterationNumber))*0.07, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        aButton.alpha = 1.0
                    }, completion: nil)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControl.Event.touchUpInside)
        }
        var frameWithUpdatedY = buttonFrame

        if(numOfButtonsInRow == numberOfColors){
            return myButtonFrame.origin.y
        }
        else {
            let leftoverArray = stringColorArray[(numOfButtonsInRow)...(numberOfColors-1)]
            frameWithUpdatedY.origin.y = frameWithUpdatedY.origin.y + buttonFrame.size.height
            return makeClassicColorsButtons(frameWithUpdatedY, stringColorArray: Array(leftoverArray),iterationNumber: iterationNumber+1)
        }
    }
    
    func makeBWColorsButtons(_ buttonFrame:CGRect){
        var myButtonFrame = buttonFrame
        var i :CGFloat = 0
        
        while i < 22{
            let hue:CGFloat = CGFloat(i) / 22.0
            let color = UIColor(hue: hue, saturation: 0, brightness: hue, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.white.cgColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControl.Event.touchUpInside)
            i = i + 2
        }
        
    }
    
    func makeRainbowButtons(_ buttonFrame:CGRect, sat:CGFloat, bright:CGFloat){
        var myButtonFrame = buttonFrame
        
        for i in 0..<11{
            let hue:CGFloat = CGFloat(i) / 11.0
            let color = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.white.cgColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    func ifEqualAllValuesDisplayEmptyString(_ textView:UITextView!){
        if(textView.text == ALL_VISIBLE_KEYS){
            textView.text = ""
        }
    }
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func resetVisibleKeys(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        UserSettings.set("", forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS")
        //UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
    }
    
    static func handleVisibleKeysSaveBug(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        //let irrelevantKey = "iSSIE_KEYBOARD_CONFIGURATION_NAME"
        let dummyColor = "1.0000,0.0000,1.0000,1.0000"
        let keyForWorkaroundArray = [KEY_ISSIE_KEYBOARD_CHARSET1_KEYS_COLOR, KEY_ISSIE_KEYBOARD_CHARSET1_TEXT_COLOR,KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR, KEY_ISSIE_KEYBOARD_CHARSET2_TEXT_COLOR, KEY_ISSIE_KEYBOARD_CHARSET3_KEYS_COLOR, KEY_ISSIE_KEYBOARD_CHARSET3_TEXT_COLOR]
        
        keyForWorkaroundArray.forEach {
            let keyForWorkaround = $0
            if let originalColor = UserSettings.string(forKey: keyForWorkaround) {
                UserSettings.set(dummyColor, forKey: keyForWorkaround)
                //UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
                UserSettings.set(originalColor, forKey: keyForWorkaround)
                //UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
            }
        }
        
//        UIView.transition(with: self.itemValue, duration: 0.3, options: [.transitionFlipFromTop ], animations: {
//        },
//                          completion:nil
//        )
    }
    
    func showAlertMessage(){
        
        var title = ""
        var description = ""
        
        if(wrapWithLocale(TITLE_ENABLE_MIDDLE) == configItem?.title) {
            if (UserDefaults(suiteName: MasterViewController.groupName)!.string(forKey:KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN) == "By Rows"){
                title = wrapWithLocale(TITLE_PLEASE_SET_COL_MODE)
                description = wrapWithLocale(TITLE_PLEASE_SET_COL_MODE_DESC)
            } else {
                return
            }
        }
        
        else if(wrapWithLocale(TITLE_COLS_VS_ROWS) == configItem?.title) {
            
            if(DetailViewController.isTwoColorsKeyboard()){
                title = wrapWithLocale(TITLE_PLEASE_ENABLE_MIDDLE)
                description = wrapWithLocale(TITLE_PLEASE_ENABLE_MIDDLE_DESC)
            }
            else {
                return
            }
        } else {
            return
        }
        self.RowColPicker.isEnabled = false
        
        let alertView = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: wrapWithLocale(TITLE_OK), style: UIAlertAction.Style.default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    static func isCurrentlyOnRows()->Bool{
        return (UserDefaults(suiteName: MasterViewController.groupName)!.string(forKey:KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN) == "By Rows")
    }
    
    static func isTwoColorsKeyboard()->Bool{
        let stringMiddleColor = UserDefaults(suiteName: MasterViewController.groupName)!.string(forKey:KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR)
        let currentMidColorAlpha = UIColor(string: stringMiddleColor!).cgColor.alpha
        return (currentMidColorAlpha == 0)
    }
    
    static func isSections()->Bool{
        let currentRowOrColumnValue = UserDefaults(suiteName: MasterViewController.groupName)!.string(forKey:KEY_ISSIE_KEYBOARD_ROW_OR_COLUMN)
        
            return (currentRowOrColumnValue == "By Sections")
    }
    
    static func switchMiddleState(){
        let UserSettings = UserDefaults(suiteName: MasterViewController.groupName)!
        let stringMiddleColor = UserSettings.string(forKey:KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR)
        let middleColor = UIColor(string: stringMiddleColor!)
        var r:CGFloat = 0,g:CGFloat = 0,b:CGFloat = 0
        var a:CGFloat = 0
        
        let currentMidColorAlpha = middleColor.cgColor.alpha
        
        if (middleColor.getRed(&r, green: &g, blue: &b, alpha: &a)){
            let disableMiddleColor = UIColor.init(red: r, green: g, blue: b, alpha: 0.0)
            let enableMiddleColor = UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
            
            let newColorStringValue = (currentMidColorAlpha == 0) ? enableMiddleColor.stringValue: disableMiddleColor.stringValue
            
            UserSettings.set(newColorStringValue, forKey:KEY_ISSIE_KEYBOARD_CHARSET2_KEYS_COLOR)
            //UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
            
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
