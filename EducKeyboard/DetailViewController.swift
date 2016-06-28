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
    
    //var configSet: NSManagedObject!
    var onTheWayToTemplates:Bool        = false
    var didNowPerformShowHideKeyboard   = false
    //var KEYBOARD_STATE_DURING_UPDATE = 0
    var nextWidth:CGFloat    = 0.0
    let MAX_COLORS_PER_ROW   = 10
    let IPAD_BUTTON_SIZE :CGFloat    = 100
    let IPAD_PRO_BUTTON_SIZE:CGFloat = 140
    let IPHONE_BUTTON_SIZE:CGFloat   = 60
    let ALL_VISIBLE_KEYS = "אבגדהוזחטיכלמנסעןפצקרשתםףךץ1234567890.,?!'•_\\|~<>$€£[]{}#%^*+=.,?!'\"-/:;()₪&@";
    let ARRAY_OF_COLORS = [
        UIColor.purpleColor(),
        "9C07E1",
        "C800FF",
        "F28DFB",
        "FF00BB",
        "8980DE",
        UIColor.blueColor(),
        "6000FF",
        "0080FF",
        "00DDFF",
        "8DEAFB",
        "8DFBCD",
        "225E16",
        "11D950",
        UIColor.greenColor(),
        UIColor.yellowColor(),
        "EDED21",
        "FF6200",
        "FF9500",
        UIColor.redColor(),
        "C70A0A",
        UIColor.brownColor(),
        "C27946",
        "F5C28C",
        "DE808D",
        UIColor.whiteColor(),
        UIColor.lightGrayColor(),
        UIColor.grayColor(),
        UIColor.darkGrayColor(),
        UIColor.blackColor()
    ]
    
    var configItem: ConfigItem? {
        didSet {
            self.configureView()
        }
    }

    
    @IBAction func TapRecognize(sender: AnyObject) {
        if(isTypeKeysScenario()){
            return
        }
        if(ToggleKeyboard.isFirstResponder()||itemValue.isFirstResponder()){
            showHideTapped(showHideKeyboard)
        }
    }
    
    
    @IBAction func showHideTapped(sender: UIButton) {
        var title:String
        let currentFirstResponder = (isTypeKeysScenario()) ?
            itemValue : ToggleKeyboard
        didNowPerformShowHideKeyboard = true
        if(currentFirstResponder.isFirstResponder()){
            
            title = wrapWithLocale(TITLE_SHOW_KEYBOARD)
            currentFirstResponder.resignFirstResponder()
            didNowPerformShowHideKeyboard = false
        }
        else{
            title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
            currentFirstResponder.becomeFirstResponder()
        }
        UIView.transitionWithView(sender, duration: 0.3, options: [.TransitionFlipFromTop ], animations: {sender.setTitle(title, forState:UIControlState.Normal )},
            completion:nil
        )
    }
    
    @IBAction func ChangedMode(sender: UISegmentedControl) {
        let values = ["By Rows","By Sections"]
        configItem?.value = values[sender.selectedSegmentIndex]
        //sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        TapRecognize(sender)
    }
    
    @IBAction func PreviewKeyboardClicked(sender: UIButton) {
        ToggleKeyboard.becomeFirstResponder()
    }
    
    @IBAction func ResetClicked(sender: UIButton) {
        let title = wrapWithLocale(TITLE_KEYBOARD_RESET_DONE)
        InitTemplates.resetToDefaultTemplate()
        UIView.transitionWithView(sender, duration: 0.3, options: [.TransitionFlipFromTop ], animations: {sender.setTitle(title, forState:UIControlState.Normal )},
            completion:nil
        )
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
        performSegueWithIdentifier("loadSaveDetail", sender: self)
    }
    func configureView() {
        
        if let toggle = self.ToggleKeyboard {
            toggle.hidden = true
        }
        
        if let item: ConfigItem = self.configItem {
            if let valueField = self.itemValue {
                if let palette = self.colorPalette {
                    if let modePicker = self.RowColPicker {
                        let font = UIFont.systemFontOfSize(24)
                        self.RowColPicker.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
                        valueField.layer.borderWidth = 1.3
                        self.title = item.title
                        
                        switch item.type {
                        case .String:
                            valueField.userInteractionEnabled  = true
                            palette.hidden = true
                            scrollView.hidden = true
                            if(!isTypeKeysScenario()){
                                valueField.text = item.value as! String
                            }
                            else if(isTypeKeysScenario()){
                                if((item.value as! String) != ""){
                                    valueField.text = item.value as! String
                                }
                            }
                            
                            modePicker.hidden = true
                            TemplatePicker.hidden = true
                        case .Color:
                            TemplatePicker.hidden = true
                            palette.hidden = false
                            scrollView.hidden = false
                            valueField.userInteractionEnabled = false
                            valueField.backgroundColor = item.value as? UIColor
                            modePicker.hidden = true
                        case .Picker:
                            TemplatePicker.hidden = true
                            valueField.userInteractionEnabled = true
                            valueField.hidden = true
                            palette.hidden = true
                            scrollView.hidden = true
                            modePicker.hidden = false
                        case .FontPicker:
                            valueField.userInteractionEnabled = true
                            TemplatePicker.hidden = true
                            valueField.hidden = true
                            palette.hidden = true
                            scrollView.hidden = true
                            modePicker.hidden = true
                        case .Templates:
                            TemplatePicker.value = 0
                            valueField.userInteractionEnabled = false
                            TemplatePicker.hidden = false
                            valueField.hidden = false
                            palette.hidden = true
                            scrollView.hidden = true
                            modePicker.hidden = true
                            showHideKeyboard.hidden = true
                        case .Reset:
                            TemplatePicker.value = 0
                            valueField.userInteractionEnabled = false
                            TemplatePicker.hidden = true
                            valueField.hidden = true
                            palette.hidden = true
                            scrollView.hidden = true
                            modePicker.hidden = true
                            ToggleKeyboard.hidden = true
                            PreviewKeyboard.hidden = true
                            showHideKeyboard.hidden = true
                            HideButton.hidden = true
                            resetButton.hidden = false
                            resetButton.setTitle(wrapWithLocale(TITLE_KEYBOARD_RESET_BUTTON) , forState: UIControlState.Normal)
                            
                        }
                    }
                }
            }
        }
        else
        {
            TemplatePicker.hidden = true
            colorPalette.hidden = true
            scrollView.hidden = true
            itemValue.hidden = true
            RowColPicker.hidden = true
            showHideKeyboard.hidden = true
        }
    }
    
    func AdditonalStyleEffects(){
        self.showHideKeyboard.layer.cornerRadius = 5
        self.itemValue.layer.cornerRadius = 5
        self.resetButton.layer.cornerRadius = 5
    }
    
    func updateColor(color: UIColor) {
        if let valueField = self.itemValue {
            if let item: ConfigItem = self.configItem {
                valueField.backgroundColor = color
                item.value = color
            }
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(textView == itemValue){
            if(didNowPerformShowHideKeyboard == false){
                let title = wrapWithLocale(TITLE_HIDE_KEYBOARD)
                UIView.transitionWithView(self.showHideKeyboard, duration: 0.3, options: [.TransitionFlipFromTop ], animations: {self.showHideKeyboard.setTitle(title, forState:UIControlState.Normal )},
                    completion:nil)
            }
            ifEqualAllValuesDisplayEmptyString(textView)
        }
        didNowPerformShowHideKeyboard = false
        return true
    }
    func textViewDidEndEditing(textView: UITextView){
    
        if let detail: ConfigItem = self.configItem {
            if let valueField = self.itemValue {
                
                if(valueField.text.isEmptyOrWhiteSpace && configItem?.key == KEY_ISSIE_KEYBOARD_VISIBLE_KEYS)
                {
                    detail.value = ALL_VISIBLE_KEYS;
                }
                else
                {
                    detail.value = valueField.text
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        //updateViewByCurrentState()
       // nextWidth   = self.view.frame.size.width
    }
    override func viewWillAppear(animated: Bool) {
        self.AdditonalStyleEffects()
        self.scrollView.contentSize.width = 0
        if(isTypeKeysScenario()){
            itemValue.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        //if(KEYBOARD_STATE_DURING_UPDATE == 0){
        let newViewWidth = self.view.frame.width
        if(nextWidth != newViewWidth){
            self.nextWidth = self.view.frame.width
            self.initColorRainbow()
        }
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayColor(sender:UIButton){
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
        UIView.transitionWithView(sender, duration: 0.3, options: [.TransitionFlipFromTop ], animations: nil,
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
                                  stringColorArray: ARRAY_OF_COLORS,iterationNumber: 0)
        buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height*1.5
        scrollView.contentSize.height = buttonFrame.origin.y
    }
    
    func makeUIColorsButtons(buttonFrame:CGRect){
        
        var myButtonFrame = buttonFrame
        var colorsArray: [UIColor] = [UIColor.blackColor(), UIColor.darkGrayColor(),UIColor.grayColor(),UIColor.lightGrayColor(), UIColor.whiteColor(), UIColor.brownColor(), UIColor.orangeColor(), UIColor.yellowColor(),UIColor.blueColor(), UIColor.purpleColor(), UIColor.greenColor()]
        //Second Row
        for i in 0..<11{
            let color = colorsArray[i]
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.whiteColor().CGColor
            aButton.layer.borderWidth = 1
            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func makeClassicColorsButtons(buttonFrame:CGRect)->CGFloat{
        
        var myButtonFrame = buttonFrame
        var stringColorArray :[String] = ["C70A0A","FF00BB","C800FF","4400FF","0080FF","00DDFF","11D950","EDED21","FF9500","FF6200","C27946"]
        //FirstbRow
        for i in 0..<11{
            let color = hexStringToUIColor(stringColorArray[i])
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.whiteColor().CGColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return myButtonFrame.origin.y
    }
    func makeClassicColorsButtons(buttonFrame:CGRect, stringColorArray :[NSObject],iterationNumber:Int)->CGFloat{
        
        var myButtonFrame = buttonFrame
        let numberOfColors = stringColorArray.count
        let numOfButtonsInRow = min(Int(floor((nextWidth) / myButtonFrame.width))-1,numberOfColors,MAX_COLORS_PER_ROW)
        for i in 0..<numOfButtonsInRow {
            let color = (stringColorArray[i] is UIColor) ? stringColorArray[i] as! UIColor : hexStringToUIColor(stringColorArray[i] as! String)
            let aButton = UIButton(frame: myButtonFrame)
            
            aButton.layer.cornerRadius = buttonFrame.width/2
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            aButton.layer.borderWidth = 1
            aButton.alpha = 0.0
            
            if let view = self.scrollView{
                view.addSubview(aButton)
                UIView.animateWithDuration(0.15, delay: (Double(i)+Double(iterationNumber))*0.07, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                        aButton.alpha = 1.0
                    }, completion: nil)
            }
            
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func makeBWColorsButtons(buttonFrame:CGRect){
        var myButtonFrame = buttonFrame
        var i :CGFloat = 0
        
        while i < 22{
            let hue:CGFloat = CGFloat(i) / 22.0
            let color = UIColor(hue: hue, saturation: 0, brightness: hue, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.whiteColor().CGColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
            i = i + 2
        }
        
    }
    
    func makeRainbowButtons(buttonFrame:CGRect, sat:CGFloat, bright:CGFloat){
        var myButtonFrame = buttonFrame
        
        for i in 0..<11{
            let hue:CGFloat = CGFloat(i) / 11.0
            let color = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            aButton.layer.borderColor = UIColor.whiteColor().CGColor
            aButton.layer.borderWidth = 1

            if let view = self.colorPalette{
                view.addSubview(aButton)
            }
            
            aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    func ifEqualAllValuesDisplayEmptyString(textView:UITextView!){
        if(textView.text == ALL_VISIBLE_KEYS){
            textView.text = ""
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
