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
    let langKeys = ["EN","HE","BOTH"]
    var onTheWayToTemplates:Bool        = false
    var didNowPerformShowHideKeyboard   = false
    //var KEYBOARD_STATE_DURING_UPDATE = 0
    var nextWidth:CGFloat    = 0.0
    let MAX_COLORS_PER_ROW   = 10
    let IPAD_BUTTON_SIZE :CGFloat    = 100
    let IPAD_PRO_BUTTON_SIZE:CGFloat = 140
    let IPHONE_BUTTON_SIZE:CGFloat   = 60
    let enKeys = "QWERTYUIOPASDFGHJKLZXCVBNM"
    let ALL_VISIBLE_KEYS = "אבגדהוזחטיכלמנסעןפצקרשתםףךץ1234567890.,?!'•_\\|~<>$€£[]{}#%^*+=.,?!'\"-/:;()₪&@QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
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
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        let unselectedColor = UIColor.init(colorLiteralRed: 0.921431005
            , green: 0.921452641, blue: 0.921441018, alpha: 1.0)
        let selectedColor = UIColor.init(colorLiteralRed: 0.450857997
            , green: 0.988297522, blue: 0.83763045, alpha: 1.0)
        
        self.languagesView.subviews.forEach {
            let button = $0 as! UIButton
            button.isSelected = false
            button.backgroundColor = unselectedColor
            button.tintColor = unselectedColor
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.selected)
            button.titleShadowColor(for: UIControlState.selected)
            button.layer.borderWidth = 5
            button.layer.borderColor = unselectedColor.cgColor
            //let currentLangKey = langKeys[button.tag-1]
            //button.setTitle(wrapWithLocale(currentLangKey) , for: UIControlState.normal)
        }

        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {
            sender.isSelected = true;
            sender.backgroundColor = selectedColor
            sender.tintColor = selectedColor
        },
                          completion:nil
        )
        
        let languageKey = sender.tag-1
        //let values = ["EN","HE","BOTH"]
            if let item: ConfigItem = self.configItem {
                item.value = langKeys[languageKey] as AnyObject?
            }
    }
    
    @IBAction func showHideTapped(_ sender: UIButton) {
        
        var title:String
        let currentFirstResponder = (isTypeKeysScenario()) ?
            itemValue : ToggleKeyboard
        didNowPerformShowHideKeyboard = true
        if(currentFirstResponder.isFirstResponder){
            
            title = wrapWithLocale(TITLE_SHOW_KEYBOARD)
            currentFirstResponder.resignFirstResponder()
            didNowPerformShowHideKeyboard = false
        }
        else{
            title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
            currentFirstResponder.becomeFirstResponder()
        }
        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {sender.setTitle(title, for:UIControlState() )},
            completion:nil
        )
    }
    
    @IBAction func ChangedMode(_ sender: UISegmentedControl) {
        let values = ["By Rows","By Sections"]
        configItem?.value = values[sender.selectedSegmentIndex] as AnyObject?
        //sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        TapRecognize(sender)
    }
    
    @IBAction func PreviewKeyboardClicked(_ sender: UIButton) {
        ToggleKeyboard.becomeFirstResponder()
    }
    
    @IBAction func ResetClicked(_ sender: UIButton) {
        let title = wrapWithLocale(TITLE_KEYBOARD_RESET_DONE)
        InitTemplates.resetToDefaultTemplate()
        UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromTop ], animations: {sender.setTitle(title, for:UIControlState() )},
            completion:nil
        )
    }
    
    func setLanguageButtonsByCurrent(){
        let prevSelectedLang:String
        var selectedButton:UIButton? = nil
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let paddingX:CGFloat = 10
        let paddingY:CGFloat = 10
        let languagesFrame = self.view.frame
        let languagesWidth = languagesFrame.width - paddingX * 2
        let langagesHeight = (languagesFrame.height - paddingY*6 - navBarHeight!) / 3
        
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
            
            if 1...3 ~= currentTag{
                button.setTitle(wrapWithLocale(currentLangKey) , for: UIControlState.normal)
                button.setTitle(wrapWithLocale(currentLangKey) , for: UIControlState.selected)
                if (currentLangKey == prevSelectedLang){
                    selectedButton = button
                }
                button.frame = buttonFrame
                buttonFrame.origin = CGPoint(x: buttonFrame.origin.x, y: buttonFrame.origin.y+paddingY + langagesHeight)
            }
        }
            languageButtonTapped(selectedButton!)
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
    func configureView() {
        
        if let toggle = self.ToggleKeyboard {
            toggle.isHidden = true
        }
        
        if let item: ConfigItem = self.configItem {
            if let valueField = self.itemValue {
                if let palette = self.colorPalette {
                    if let modePicker = self.RowColPicker {
                        let font = UIFont.systemFont(ofSize: 24)
                        self.RowColPicker.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
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
                        case .picker:
                            languagesView.isHidden = true
                            TemplatePicker.isHidden = true
                            valueField.isUserInteractionEnabled = true
                            valueField.isHidden = true
                            palette.isHidden = true
                            scrollView.isHidden = true
                            modePicker.isHidden = false
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
                            resetButton.setTitle(wrapWithLocale(TITLE_KEYBOARD_RESET_BUTTON) , for: UIControlState())
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
        self.itemValue.layer.cornerRadius = 5
        self.resetButton.layer.cornerRadius = 5
    }
    
    func updateColor(_ color: UIColor) {
        if let valueField = self.itemValue {
            if let item: ConfigItem = self.configItem {
                valueField.backgroundColor = color
                item.value = color
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView == itemValue){
            if(didNowPerformShowHideKeyboard == false){
                let title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
                UIView.transition(with: self.showHideKeyboard, duration: 0.3, options: [.transitionFlipFromTop ], animations: {self.showHideKeyboard.setTitle(title, for:UIControlState() )},
                    completion:nil)
            }
            ifEqualAllValuesDisplayEmptyString(textView)
        }
        didNowPerformShowHideKeyboard = false
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView){
    
        if let detail: ConfigItem = self.configItem {
            if let valueField = self.itemValue {
                
                if(valueField.text.isEmptyOrWhiteSpace && configItem?.key == KEY_ISSIE_KEYBOARD_VISIBLE_KEYS)
                {
                    detail.value = ALL_VISIBLE_KEYS as AnyObject?;
                }
                else
                {
                    detail.value = valueField.text as AnyObject?
                }
            }
        }
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
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        let title = wrapWithLocale(TITLE_SHOW_KEYBOARD)
        if (showHideKeyboard.currentTitle != title){
            UIView.transition(with: showHideKeyboard, duration: 0.3,
                options: [.transitionFlipFromTop ], animations:
                {self.showHideKeyboard.setTitle(title, for:UIControlState() )},completion:nil)
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
    
    func displayColor(_ sender:UIButton){
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
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControlEvents.touchUpInside)
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
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControlEvents.touchUpInside)
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
                UIView.animate(withDuration: 0.15, delay: (Double(i)+Double(iterationNumber))*0.07, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        aButton.alpha = 1.0
                    }, completion: nil)
            }
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControlEvents.touchUpInside)
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
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControlEvents.touchUpInside)
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
            
            aButton.addTarget(self, action: #selector(DetailViewController.displayColor(_:)), for: UIControlEvents.touchUpInside)
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
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if (cString.characters.count != 6) {
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
}
