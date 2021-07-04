
import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate{
    
    static let groupName = "group.com.issieshapiro.Issieboard"
    static let invisibleSpaceFix = "⠀"
    static let rowsOfKeysHEpunctuation = ["","ְ","ֱ","ֲ","ֻ","ֹ","ּ","ֳ","ִ","ֵ","ֶ","ַ","ָ",""]
    //static let lamedForBugSolution = "\u{05b9}"+"\u{05b9}"+"ל"+"\u{05b9}"
    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.07
    let timeForPunctuationPopUp = 2
    let secondPuncLetters = "שׁשׂכּבּפּ"
    var keyboard: Keyboard!
    var forwardingView: ForwardingView!
    var layout: KeyboardLayout?
    var heightConstraint: NSLayoutConstraint?
    var buttonsArray:[UIButton] = []
    var timeCounterForLongPress:NSDate = NSDate()
    var heightsForOrientations = [UIInterfaceOrientation:CGFloat]()
    var settingsView: ExtraView?
    var pressDownStarted:Bool = false
    var pressDownCompleted:Bool = false
    var punctuationToggled = false
    var togglePuncButton:KeyboardKey? = nil
    
    var currentMode: Int {
        didSet {
            if oldValue != currentMode {
                setMode(currentMode)
            }
        }
    }
    
    var backspaceActive: Bool {
        get {
            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
        }
    }
    var backspaceDelayTimer: Timer?
    var backspaceRepeatTimer: Timer?
    
    enum AutoPeriodState {
        case noSpace
        case firstSpace
    }
    
    var autoPeriodState: AutoPeriodState = .noSpace
    var lastCharCountInBeforeContext: Int = 0
    
    var keyboardHeight: CGFloat {
        get {
            if let constraint = self.heightConstraint {
                return constraint.constant
            }
            else {
                return 0
            }
        }
        set {
            self.setHeight(newValue)
        }
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.keyboard = standardKeyboard()
        self.currentMode = KeyboardViewController.getPreviousCurrentMode()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.forwardingView = ForwardingView(frame: CGRect.zero)
        self.view.addSubview(self.forwardingView)
        initHeightsForOrientation()
        
        // UserDefaults(suiteName: "group.issieshapiro.com.issiboard")?.addObserver(self, selector: #selector(KeyboardViewController.defaultsChanged(_:)), name: UserDefaults.didChangeNotification, object: nil)
        //keyboard observers TODO:Remove
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChange:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardDidHideNotification, object: nil)*/
         //   NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("methodOfReceivedNotification:"), name:"NotificationIdentifier", object: nil)
       /* NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            //self.keyboard = standardKeyboard()
            self.updateAppearances(false)
            var x = "x"
            if let savedValue = NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!.stringForKey("gotNotification") {
            x += savedValue
            }
                
            NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!.setObject("XXX" + x, forKey: "gotNotification")
            NSUserDefaults(suiteName: "group.issieshapiro.com.issiboard")!.synchronize()
        }*/
        
           self.view.backgroundColor = UIColor.cyan
        //addConstraintForKeyboardHeight()
       // self.view.frame =  (self.layout?.superview.frame)!
        
    }
    
    func addConstraintForKeyboardHeight(heightParam:CGFloat) {
        if((heightConstraint ) != nil){
            self.view.removeConstraint(heightConstraint!)
        }
        
    heightConstraint = NSLayoutConstraint(item: self.view as Any,
    attribute: NSLayoutConstraint.Attribute.height,
    relatedBy: NSLayoutConstraint.Relation.equal,
    toItem: nil,
    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
    multiplier: 0.0,
    constant: heightParam)
    self.view.addConstraint(heightConstraint!) //<< This constraint has issues in iOS 14
        //var addConstraint = false
//        if (heightParam == 352) {
//            self.view.addConstraint(heightConstraint!)
//        }
    }
    
     
/*
    func methodOfReceivedNotification(_ notification: Notification){
        //Take Action on Notification
        UserDefaults(suiteName: KeyboardViewController.groupName)!.set("XXX", forKey: "gotNotification")
        UserDefaults(suiteName: KeyboardViewController.groupName)!.synchronize()
        fatalError("NSCoding not supported")
    }
 */
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    deinit {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    func defaultsChanged(_ notification: Notification) {
        var defaults = notification.object as! UserDefaults
        //defaults.synchronize()//23.9.2020 I try to remove synchronize and see if all works
        defaults = UserDefaults.standard
        //var i : Int = defaults.integerForKey("defaultBackgroundColor")
        //defaults.synchronize()//23.9.2020 I try to remove synchronize and see if all works
    }
    func updatePrimaryLanguage(){
        let he = "he-IL"
        let en = "en-US"
        /*
         Keyboard Pages
         0 - Hebrew 1 - HebrewNumbers, 2 - HebrewSymbols,
         3 - English Loweer, 4 - EnglishUpper, 5 - EnglishNumbers, 6 - EnglishSymbols
         */
        self.primaryLanguage =  he
        if(self.currentMode < 3 ){
          self.primaryLanguage =  he
        }
        else{
            self.primaryLanguage =  en
        }
    }

    static func setPreviousCurrentMode(_ currentMode:Int){
        print("Keyboard hidden")
        let valueToSave = String(currentMode)
        UserDefaults(suiteName: KeyboardViewController.groupName)!.set(valueToSave, forKey: "currentMode")
        //UserDefaults(suiteName: KeyboardViewController.groupName)!.synchronize()//UserSettings.synchronize()//23.9.2020 I try to remove synchronize and see if all works
    }
    
    static func getPreviousCurrentMode()->Int{
        if let savedValue = UserDefaults(suiteName: KeyboardViewController.groupName)!.string(forKey: "currentMode") {
            print(savedValue)
            return Int(savedValue)!
        }
        else{
            //No Previous, so we'll return according to Keyboard language
            let userDefaults:UserDefaults
                = UserDefaults(suiteName: KeyboardViewController.groupName)!
            let cLanguage = userDefaults.string(forKey: "ISSIE_KEYBOARD_LANGUAGES") ?? Settings.getPreferredLanguage()
            switch cLanguage {
            case "EN":
                return 3
            case "AR","AR_HE","AR_EN":
                return 7
            case "HE":
                return 0
            case "BOTH":
                return 0
            default:
                return 0
            }
        }
    }
    
    var kludge: UIView?
    func setupKludge() {
        if self.kludge == nil {
            let kludge = UIView()
            self.view.addSubview(kludge)
            kludge.translatesAutoresizingMaskIntoConstraints = false
            kludge.isHidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.view.addConstraints([a, b, c, d])
            self.kludge = kludge
        }
    }
    
    var constraintsAdded: Bool = false
    
    func setupLayout() {
        if !constraintsAdded {
            self.layout = type(of: self).layoutClass.init(model: self.keyboard, superview: self.forwardingView, layoutConstants: type(of: self).layoutConstants, globalColors: type(of: self).globalColors)
            
            self.layout?.initialize()
            //self.setMode(0) <<<
            self.setMode(currentMode)
            self.setupKludge()
            self.addInputTraitsObservers()
            self.constraintsAdded = true
            
        }
    }
    /*
    override func viewDidLoad() {
        let interfaceOrientation = self.preferredInterfaceOrientationForPresentation
        //self.interfaceOrientation
        self.keyboardHeight = self.heightForOrientation(interfaceOrientation, withTopBanner: false)
        addConstraintForKeyboardHeight(heightParam: self.keyboardHeight)
    }*/
    
    override func viewWillLayoutSubviews() {
        let interfaceOrientation = self.preferredInterfaceOrientationForPresentation
        //self.interfaceOrientation
        self.keyboardHeight = self.heightsForOrientations[interfaceOrientation]!//self.heightForOrientation(interfaceOrientation, withTopBanner: false)
        //addConstraintForKeyboardHeight(heightParam: self.keyboardHeight) //try to fix ios 14
    }
    
    var lastLayoutBounds: CGRect?
    override func viewDidLayoutSubviews() {
        if view.bounds == CGRect.zero {
            return
        }
        
        //self.load
        
        let interfaceOrientation = self.preferredInterfaceOrientationForPresentation
        //self.interfaceOrientation
        self.setupLayout()
        //UIApplication().statusBarOrientation
        //let orientationSavvyBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.heightForOrientation(interfaceOrientation, withTopBanner: false))
        let orientationSavvyBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.heightsForOrientations[interfaceOrientation]!)
        
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
        }
        else {
            self.forwardingView.frame = orientationSavvyBounds
            self.layout?.layoutKeys(self.currentMode)
            self.lastLayoutBounds = orientationSavvyBounds
            self.setupKeys()
        }
        
        let newOrigin = CGPoint(x: 0, y: self.view.bounds.height - self.forwardingView.bounds.height)
        self.forwardingView.frame.origin = newOrigin
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let interfaceOrientation = self.preferredInterfaceOrientationForPresentation
        //self.interfaceOrientation
        self.keyboardHeight = self.heightsForOrientations[interfaceOrientation]!
        addConstraintForKeyboardHeight(heightParam: self.keyboardHeight) //<< try to fix constraint issues in iOS 14
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        KeyboardViewController.setPreviousCurrentMode(self.currentMode)
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.forwardingView.resetTrackedViews()

        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = true
            }
        }
        
        self.keyboardHeight = self.heightsForOrientations[toInterfaceOrientation]!
        addConstraintForKeyboardHeight(heightParam: self.keyboardHeight)
        
        if(punctuationToggled){
            punctuationToggleTapped(togglePuncButton!)
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = false
            }
        }
        
    }
    
    func initHeightsForOrientation(){
        heightsForOrientations[UIInterfaceOrientation.portrait] = heightForOrientation(UIInterfaceOrientation.portrait, withTopBanner: false)
        heightsForOrientations[UIInterfaceOrientation.portraitUpsideDown] = self.heightForOrientation(UIInterfaceOrientation.portraitUpsideDown, withTopBanner: false)
        heightsForOrientations[UIInterfaceOrientation.landscapeLeft] = heightForOrientation(UIInterfaceOrientation.landscapeLeft, withTopBanner: false)
        heightsForOrientations[UIInterfaceOrientation.landscapeRight] = self.heightForOrientation(UIInterfaceOrientation.landscapeRight, withTopBanner: false)
    }
    
    func heightForOrientation(_ orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    
        let actualScreenWidth = (UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale)
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))
     
        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight )
    }
    
    func setupKeys() {
        self.updatePrimaryLanguage()
        if self.layout == nil {
            return
        }
        
        for page in keyboard.pages {
            for rowKeys in page.rows {
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
                        switch key.type {
                        case Key.KeyType.keyboardChange:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.advanceTapped(_:)), for: .touchUpInside)
                        case Key.KeyType.backspace:
                            let cancelEvents: UIControl.Event = [UIControl.Event.touchUpInside, UIControl.Event.touchUpInside, UIControl.Event.touchDragExit, UIControl.Event.touchUpOutside, UIControl.Event.touchCancel, UIControl.Event.touchDragOutside]
                
                                keyView.addTarget(self, action: #selector(KeyboardViewController.backspaceDown(_:)), for: .touchDown)
                                keyView.addTarget(self, action: #selector(KeyboardViewController.backspaceUp(_:)), for: cancelEvents)
                        case Key.KeyType.modeChange:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.modeChangeTapped(_:)), for: .touchDown)
                        case Key.KeyType.character:
                            if(key.keyTitle!.lowercased() == "abc"){
                                keyView.addTarget(self, action: #selector(KeyboardViewController.modeChangeTapped(_:)), for: .touchDown)
                            }
                        case Key.KeyType.dismissKeyboard :
                            keyView.addTarget(self, action: #selector(KeyboardViewController.dismissKeyboardTapped(_:)), for: .touchDown)
                        case Key.KeyType.punctuation :
                            keyView.addTarget(self, action: #selector(KeyboardViewController.punctuationToggleTapped(_:)), for: .touchDown)
                        default:
                            break
                        }
                        
                        if key.isCharacter && key.type != Key.KeyType.hiddenKey && !(key.keyTitle!.lowercased() == "abc"){
                            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                                keyView.addTarget(self, action: #selector(KeyboardViewController.showPopup(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
                                keyView.addTarget(keyView, action: Selector(("hidePopup")), for: [.touchDragExit, .touchCancel])
                                keyView.addTarget(self, action: #selector(KeyboardViewController.hidePopupDelay(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside])
                            }
                        }
                        if key.type == Key.KeyType.undo {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.undoTapped(_:)), for: .touchUpInside)

                        }
                        
                       if key.hasOutput && key.type != Key.KeyType.hiddenKey {
                        keyView.addTarget(self, action: #selector(KeyboardViewController.keyPressedHelper(_:)), for: .touchUpInside)
                        keyView.addTarget(self, action: #selector(KeyboardViewController.resetTimer(_:)), for: .touchDown)
                        /*
                        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(KeyboardViewController.keyPressedHelperLong(_:)))
                        longPressGesture.minimumPressDuration = 1.0
                        longPressGesture.allowableMovement = 15
                        
                        longPressGesture.delegate = self
                        keyView.addGestureRecognizer(longPressGesture)
                         */
                       }
                        
                        if key.type != Key.KeyType.modeChange {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.highlightKey(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
                            keyView.addTarget(self, action: #selector(KeyboardViewController.unHighlightKey(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
                        }
                        //I commented this to cancel sounds, as requested. 7.5.2017
                        /*if key.type != Key.KeyType.hiddenKey {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.playKeySound), for: .touchDown)
                        }*/
                    }
                }
            }
        }
    }
    
    /////////////////
    // POPUP DELAY //
    /////////////////
    
    var keyWithDelayedPopup: KeyboardKey?
    var popupDelayTimer: Timer?
    
    @objc func showPopup(_ sender: KeyboardKey) {
        if sender == self.keyWithDelayedPopup {
            self.popupDelayTimer?.invalidate()
        }
        sender.showPopup()
    }
    
    @objc func hidePopupDelay(_ sender: KeyboardKey) {
        self.popupDelayTimer?.invalidate()
        
        if sender != self.keyWithDelayedPopup {
            self.keyWithDelayedPopup?.hidePopup()
            self.keyWithDelayedPopup = sender
        }
        
        if sender.popup != nil {
            self.popupDelayTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(KeyboardViewController.hidePopupCallback), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hidePopupCallback() {
        self.keyWithDelayedPopup?.hidePopup()
        self.keyWithDelayedPopup = nil
        self.popupDelayTimer = nil
    }
    
    /////////////////////
    // POPUP DELAY END //
    /////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textDidChange(_ textInput: UITextInput?) {
        self.contextChanged()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        self.contextChanged()
    }
    
    
    func contextChanged() {
        self.autoPeriodState = .noSpace
    }
    
    func setHeight(_ height: CGFloat) {
            self.heightConstraint?.constant = height
    }
    
    func updateAppearances(_ appearanceIsDark: Bool) {
        self.layout?.updateKeyAppearance()
        self.settingsView?.darkMode = appearanceIsDark
    }
    
    @objc func highlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = true
    }
    
    @objc func unHighlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = false
    }
    @objc func resetTimer(_ sender: KeyboardKey) {
        NSLog("resetTimer")
        self.timeCounterForLongPress = NSDate()
        pressDownStarted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(timeForPunctuationPopUp)) {
            if (self.pressDownStarted){
                //self.keyPressedHelper(sender)
                //self.pressDownCompleted = true
                let now = NSDate()
                let interval = now.timeIntervalSince(self.timeCounterForLongPress as Date)
                NSLog("interval: ", interval)
                if (interval > Double(self.timeForPunctuationPopUp)) {
                    if let model = self.layout?.keyForView(sender) {
                        self.keyPressedLong(model)
                        self.pressDownCompleted = true
                    }
                }
            }
            
        }
        
    }
    /*
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let thePuncView = self.view.viewWithTag(11) {
            if(touch.view != thePuncView){
                self.dismissPuncIfVisible()
            }
        }
        return false
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let thePuncView = self.view.viewWithTag(11) {
            guard let location = touch?.location(in: thePuncView) else { return }
            if !thePuncView.frame.contains(location){
                self.dismissPuncIfVisible()
            }
        }
    }
  */
    func sampleForLongPress(initialValue: NSDate){
        
    }

    
    @objc func keyPressedHelper(_ sender: KeyboardKey) {
        pressDownStarted = false
        if(pressDownCompleted){
            pressDownCompleted = false
            return
        }
        dismissPuncIfVisible()
        if (punctuationToggled){
            if let model = self.layout?.keyForView(sender) {
                self.keyPressedLong(model)
                return
            }
        }
        NSLog("keyPressedHelper")
        if let model = self.layout?.keyForView(sender) {
            let now = NSDate()
            let interval = now.timeIntervalSince(self.timeCounterForLongPress as Date)
            NSLog("interval: ", interval)
            if (interval < Double(timeForPunctuationPopUp)) {
                self.keyPressedShort(model)
            }
            else {
                self.keyPressedLong(model)
            }
        }
    }
    
    func keyPressedHelperLong(_ sender: KeyboardKey) {
        NSLog("keyPressedHelperLong")
        if let model = self.layout?.keyForView(sender) {
            self.keyPressedLong(model)
            
            //if model.type == Key.KeyType.return {
            //    self.currentMode = KeyboardViewController.getPreviousCurrentMode()
            //}
            //var lastCharCountInBeforeContext: Int = 0
            //var readyForDoubleSpacePeriod: Bool = true
            
            //self.handleAutoPeriod(model)//<< removed that 25.12.2016
        }
    }
    func handleAutoPeriod(_ key: Key) {

        if self.autoPeriodState == .firstSpace {
            if key.type != Key.KeyType.space {
                self.autoPeriodState = .noSpace
                return
            }
            
            let charactersAreInCorrectState = { () -> Bool in
                let previousContext = (self.textDocumentProxy as UITextDocumentProxy).documentContextBeforeInput
                
                if previousContext == nil || (previousContext!).count < 3 {
                    return false
                }
                
                let index = previousContext!.endIndex
                
               // index = <#T##Collection corresponding to `index`##Collection#>.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
               // index = <#T##Collection corresponding to `index`##Collection#>.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
               // index = <#T##Collection corresponding to `index`##Collection#>.index(before: index)
                let char = previousContext![index]
                if self.characterIsWhitespace(char) || self.characterIsPunctuation(char) || char == "," {
                    return false
                }
                
                return true
            }()
            
            if charactersAreInCorrectState {
                (self.textDocumentProxy as UITextDocumentProxy).deleteBackward()
                (self.textDocumentProxy as UITextDocumentProxy).deleteBackward()
                (self.textDocumentProxy as UITextDocumentProxy).insertText(".")
                (self.textDocumentProxy as UITextDocumentProxy).insertText(" ")
            }
            
            self.autoPeriodState = .noSpace
        }
        else {
            if key.type == Key.KeyType.space {
                self.autoPeriodState = .firstSpace
            }
        }
    }
    
    func cancelBackspaceTimers() {
        self.backspaceDelayTimer?.invalidate()
        self.backspaceRepeatTimer?.invalidate()
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = nil
    }
    
    @objc func backspaceDown(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
        
   //     if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            self.textDocumentProxy.deleteBackward()
   //     }

        self.backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceDelayCallback), userInfo: nil, repeats: false)
    }
    
    @objc func backspaceUp(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
    }
    
    @objc func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceRepeatCallback), userInfo: nil, repeats: true)
    }
    
    @objc func backspaceRepeatCallback() {
        //I commented this to cancel sounds, as requested. 7.5.2017
        //self.playKeySound()
        
      //  if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            self.textDocumentProxy.deleteBackward()
      //  }
    }
    
    @objc func dismissKeyboardTapped (_ sender : KeyboardKey) {
        self.dismissKeyboard()
    }
    
    @objc func punctuationToggleTapped (_ sender : KeyboardKey) {
        let borderWidth = sender.frame.size.height / 10
        sender.layer.borderColor = sender.textColor.cgColor
        sender.layer.borderWidth = sender.layer.borderWidth == borderWidth ? 0 : borderWidth
        punctuationToggled = sender.layer.borderWidth == borderWidth
        sender.layer.cornerRadius = borderWidth
        sender.clipsToBounds = true
        togglePuncButton = sender
    }
    
    @objc func undoTapped (_ sender : KeyboardKey) {
    }
 
    
    @objc func modeChangeTapped(_ sender: KeyboardKey) {
        if let toMode = self.layout?.viewToModel[sender]?.toMode {
            self.currentMode = toMode
            self.updatePrimaryLanguage()
        }
    }
    
    func setMode(_ mode: Int) {
        self.forwardingView.resetTrackedViews()
        self.layout?.layoutKeys(mode)
        self.setupKeys()
    }
    
    @objc func advanceTapped(_ sender: KeyboardKey) {
        self.forwardingView.resetTrackedViews()
        self.advanceToNextInputMode()
    }
    
    func characterIsPunctuation(_ character: Character) -> Bool {
        return (character == ".") || (character == "!") || (character == "?")
    }
    
    func characterIsNewline(_ character: Character) -> Bool {
        return (character == "\n") || (character == "\r")
    }
    
    func characterIsWhitespace(_ character: Character) -> Bool {
        return (character == " ") || (character == "\n") || (character == "\r") || (character == "\t")
    }
    
    func stringIsWhitespace(_ string: String?) -> Bool {
        if string != nil {
            for char in (string!) {
                if !characterIsWhitespace(char) {
                    return false
                }
            }
        }
        return true
    }
    
    func playKeySound() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            AudioServicesPlaySystemSound(1104)
        })
    }
    
    //////////////////////////////////////
    // MOST COMMONLY EXTENDABLE METHODS //
    //////////////////////////////////////
    
    class var layoutClass: KeyboardLayout.Type { get { return KeyboardLayout.self }}
    class var layoutConstants: LayoutConstants.Type { get { return LayoutConstants.self }}
    class var globalColors: GlobalColors.Type { get { return GlobalColors.self }}
    
    @objc func dismissPuncIfVisible(){
        if let thePuncView = self.view.viewWithTag(11) {
            let opaqueView = self.view.viewWithTag(12)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                thePuncView.alpha = 0
                opaqueView?.alpha = 0
            }) { _ in
                thePuncView.removeFromSuperview()
                opaqueView?.removeFromSuperview()
                self.buttonsArray = []
            }
        }
    }
    @objc func puncPress(sender:UIButton){
        self.textDocumentProxy.insertText(sender.title(for: UIControl.State.selected)!)
        dismissPuncIfVisible()
        //self.dismiss(animated: true, completion: nil)
    }
    func keyPressedShort(_ key: Key) {
        self.textDocumentProxy.insertText(key.getKeyOutput())
    }
    
    func createAttributedButtonTitle(_ punc:String, char:String, buttonColor:UIColor, textColor:UIColor)->NSMutableAttributedString? {
        guard
            let fontBold = UIFont(name: "HelveticaNeue-Bold", size: 52),
            let fontRegular = UIFont(name: "HelveticaNeue-Medium", size: 52)  else { return nil}
        
        let dictBold:[String:Any] = [
            //            NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):fontBold,
            //NSStrokeWidthAttributeName:3.0,
            //NSParagraphStyleAttributeName:,
            //NSStrokeColorAttributeName: UIColor.white,
            
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): buttonColor.invertColor()
        ]
        
        let dictRegular:[String:Any] = [
            //            NSUnderlineStyleAttributeName:NSUnderlineStyle.styleNone.rawValue,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):fontRegular,
            //NSParagraphStyleAttributeName:style,
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): textColor,
            //            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        let attString = NSMutableAttributedString()

        attString.append(NSAttributedString(string: char, attributes: convertToOptionalNSAttributedStringKeyDictionary(dictRegular)))
        attString.append(NSAttributedString(string: punc, attributes: convertToOptionalNSAttributedStringKeyDictionary(dictBold)))
        
        return attString
    }
    
    
    func keyPressedLong(_ key: Key) {
        // punctuation row, for later implementation
        let PAD_WIDTH = 5
        let PAD_HEIGTH = 5
        //שׂ

        

        //let rowsOfKeysARpunctuation = [ " ً"," ٰ", "ـ", " ُ", " ِ", " َ", " ّ", " ٌ", " ً", " ٍ", " ْ",""]
        //let rowsOfKeysHEpunctuation = ["ׁ","ְ","ֱ","ֲ","ֻ","ֹ","ּ","ֳ","ִ","ֵ","ֶ","ַ","ָ","ׂ"]
        //let rowsOfKeysHEpunctuationSh = ["ְ","ֱ","ֲ","ֻ","ֹ","ּ","ֳ","ִ","ֵ","ֶ","ַ","ָ","ׂ","ׁ"," ׂ ","ׁ"]9.9.2018
        let rowsOfKeysHEpunctuationSh = ["ְ","ֱ","ֲ","ֻ","ֹ","ּ","ֳ","ִ","ֵ","ֶ","ַ","ָ","ׂ","ׁ"]
        var keysPunctuation:[String] =  []
        let rowsOfKeysARpunctuation = ["","ُ","ِ","َ","ّ","ٌ","ً","ٍ","ْ",""]

        let notPuncedChars = "םןףץ.,"
        let secondPuncLetters = "כּשׁשׂבּפּ"
        //let secondPuncLetter = ""
        /*
         Keyboard Pages
         0 - Hebrew
         7 - Arabic
         All others don't need pucntuation
         */
        switch key.getPage() {
        case 0:
            if(key.isCharacter){
                if ((notPuncedChars.range(of: key.getKeyTitle())) == nil) {
                    keysPunctuation = KeyboardViewController.rowsOfKeysHEpunctuation
                    if (key.getKeyTitle() == "ש"){
                       keysPunctuation = rowsOfKeysHEpunctuationSh
                    }
                }
            }
        case 7:
            if(key.isCharacter){
                keysPunctuation = rowsOfKeysARpunctuation
            }
        default: break
        }
        if (keysPunctuation.count == 0){
            self.textDocumentProxy.insertText(key.getKeyOutput())
            return
        }
        let arrayLength = keysPunctuation.count
        let arrayHalfLength = Int(arrayLength/2)// - 1
        let viewForKey = self.layout?.viewForKey(key)
        let buttonWidth = max((viewForKey?.frame.size.height)!,(viewForKey?.frame.size.width)!)
        let frameWidth =  CGFloat(PAD_WIDTH) + CGFloat(arrayHalfLength) * ( buttonWidth + CGFloat(PAD_WIDTH))
        let frameHeight = CGFloat(PAD_HEIGTH) + 2 * (buttonWidth + CGFloat(PAD_HEIGTH))
        let viewController = UIViewController()
        viewController.view = UIView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
        viewController.view.backgroundColor = UIColor.lightGray
        viewController.view.tag = 11
        var currentFrameX = CGFloat(PAD_WIDTH)
        let currentFrameY = CGFloat(PAD_HEIGTH)

        let opaqueView = UIView(frame: self.view.frame)
        opaqueView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.7)
        opaqueView.tag = 12
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(KeyboardViewController.dismissPuncIfVisible))
        tap.delegate = self
        opaqueView.addGestureRecognizer(tap)

        //opaqueView.addTarget(opaqueView, action:#selector(KeyboardViewController.dismissPuncIfVisible), for: .touchUpInside)
        for index in 0...(arrayHalfLength-1) {
            var keyTitle = ""
            var keyTitle2 = ""
            
            var attTitle = NSAttributedString(string: "")
            var attTitle2 = NSAttributedString(string: "")
            let buttonsColor = viewForKey?.color
            let textcolor = viewForKey?.textColor
            switch key.getPage() {
                case 0:
                      keyTitle =  key.getKeyTitle() + keysPunctuation[index]
                      keyTitle2 =  key.getKeyTitle() + keysPunctuation[index+arrayHalfLength]
                      
                      attTitle = createAttributedButtonTitle(keysPunctuation[index], char: key.getKeyTitle(),buttonColor: buttonsColor!, textColor: textcolor!)!
                      attTitle2 = createAttributedButtonTitle(keysPunctuation[index+arrayHalfLength], char: key.getKeyTitle(),buttonColor: buttonsColor!, textColor: textcolor!)!
                      
                      if(key.getKeyTitle() == "ל"  && index == 5){
                        let attTitleL = NSMutableAttributedString()
                        attTitleL.append(NSAttributedString(string: KeyboardViewController.invisibleSpaceFix))
                        attTitleL.append(attTitle)
                        attTitleL.append(NSAttributedString(string: KeyboardViewController.invisibleSpaceFix))
                        attTitle = attTitleL
                        keyTitle = KeyboardViewController.invisibleSpaceFix+keyTitle+KeyboardViewController.invisibleSpaceFix
                }
                case 7:

                    //keyTitle =  keysPunctuation[index] + key.getKeyTitle()
                    //keyTitle2 =  keysPunctuation[index+arrayHalfLength]  + key.getKeyTitle()
                   
                keyTitle =   key.getKeyTitle() + keysPunctuation[index]
                keyTitle2 =  key.getKeyTitle() + keysPunctuation[index+arrayHalfLength]
                
                attTitle = createAttributedButtonTitle(keysPunctuation[index], char: key.getKeyTitle(),buttonColor: buttonsColor!, textColor: textcolor!)!
                attTitle2 = createAttributedButtonTitle(keysPunctuation[index+arrayHalfLength], char: key.getKeyTitle(),buttonColor: buttonsColor!, textColor: textcolor!)!

                default: break
            }
            
          /*  if(key.getKeyTitle() == "ל" && index==5){
                keyTitle = KeyboardViewController.lamedForBugSolution
            }*/
            
            let button1 = UIButton(frame: CGRect(x: currentFrameX, y: currentFrameY, width: buttonWidth, height: buttonWidth))
            button1.backgroundColor = viewForKey?.color
            button1.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            button1.setTitleColor(viewForKey?.textColor, for: UIControl.State.normal)
            button1.titleLabel?.font = viewForKey?.label.font
            button1.setTitle(key.getKeyTitle() + keysPunctuation[index].trimmingCharacters(in: CharacterSet.init(charactersIn: KeyboardViewController.invisibleSpaceFix)) , for: UIControl.State.selected)
            button1.setTitle(keyTitle, for: UIControl.State.normal)
            //button1.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
            button1.layer.cornerRadius = buttonWidth/2
            //let attTitle = createAttributedButtonTitle(keysPunctuation[index].trimmingCharacters(in: CharacterSet.init(charactersIn: KeyboardViewController.invisibleSpaceFix)), char: key.getKeyTitle())
            //button1.setAttributedTitle(attTitle, for: UIControlState.normal)
            viewController.view.addSubview(button1)
            
            let button2 = UIButton(frame: CGRect(x: currentFrameX, y: currentFrameY + buttonWidth +  CGFloat(PAD_HEIGTH) , width: buttonWidth, height: buttonWidth))
            button2.backgroundColor = viewForKey?.color
            button2.setTitleColor(viewForKey?.textColor, for: UIControl.State.normal)
            button2.titleLabel?.font = viewForKey?.label.font
            button2.setTitle(keyTitle2, for: UIControl.State.selected
            )
            button2.setTitle(keyTitle2, for: UIControl.State.normal)
            //button2.setAttributedTitle(attTitle2, for: UIControlState.normal)
            //button2.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
            button2.layer.cornerRadius = buttonWidth/2
            viewController.view.addSubview(button2)
            
            currentFrameX = currentFrameX + CGFloat(PAD_WIDTH) + buttonWidth
            keyTitle2 =  key.getKeyTitle() + keysPunctuation[index+arrayHalfLength]
            if(secondPuncLetters.contains(keyTitle) || keysPunctuation[index] == " ّ"){
                button1.addTarget(self, action: #selector(KeyboardViewController.keyPressedSecondHelper(_:)), for: .touchUpInside)
            }
            else{
                button1.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
            }
            if(secondPuncLetters.contains(keyTitle2) || keysPunctuation[index + arrayHalfLength] == "ٌ"){
                button2.addTarget(self, action: #selector(KeyboardViewController.keyPressedSecondHelper(_:)), for: .touchUpInside)
            }
            else{
                button2.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
            }
            
            //fix voiceOver bug 26.6.21
            button1.accessibilityTraits = [.keyboardKey]
            button2.accessibilityTraits = [.keyboardKey]
            buttonsArray.append(button1)
            buttonsArray.append(button2)
        }
        /*
        let button1 = UIButton(frame: (viewForKey?.frame)!)
        button1.backgroundColor = viewForKey?.backgroundColor
        button1.setTitle(key.getKeyTitle() + rowsOfKeysHEpunctuation[4], for: UIControlState.normal)
        button1.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
        viewController.view.addSubview(button1)
        */
        viewController.modalPresentationStyle = .overCurrentContext
        let popOver = viewController.popoverPresentationController
        popOver?.delegate = self
        popOver?.permittedArrowDirections = .any
        
        popOver?.sourceView = viewForKey
        popOver?.sourceRect = (viewForKey?.frame.standardized)!
        viewController.view.layer.cornerRadius = buttonWidth / 2
        viewController.view.layer.borderWidth = 1
        //viewController.view.layer.borderColor = UIColor.darkGray as! CGColor
        
        viewController.view.center = self.view.center
        //self.view.addSubview(viewController.view)
        viewController.view.alpha = 0
        self.view.addSubview(opaqueView)
        self.view.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            viewController.view.alpha = 1
        }) 
        //present(viewController, animated: true, completion:nil)
       // if let proxy = (self.textDocumentProxy as? UIKeyInput) {
            //self.textDocumentProxy.insertText(key.getKeyOutput())
       // }
    }
    
    
    @objc func keyPressedSecondHelper(_ sender: UIButton) {
        var keyTitle1 = ""
        var keyTitle2 = ""
        //var index = 0;

        let rowsOfKeysHEpunctuationSH = ["שׁ","שׂ"] //["ׂ","ׁ"].map{"ש" + $0}
        //let rowsOfKeysARpunctuation = ["ً","ٰ","ـ","ُ","ِ","َ","ّ","ٌ","ً","ٍ","ْ",""]
        let rowsOfKeysARpunctuation = ["","ُ","ِ","َ","ّ","ٌ","ً","ٍ","ْ",""]
        
        var puncArray = KeyboardViewController.rowsOfKeysHEpunctuation.map {(($0 == "ּ")&&("בּפּ".contains(sender.currentTitle!))) ? sender.currentTitle! : sender.currentTitle! + $0}
        if("שׁשׂ".contains(sender.currentTitle!)){
            puncArray =  puncArray.filter {$0 != ""} + rowsOfKeysHEpunctuationSH
        }
        if(sender.currentTitle!.contains("ٌ")){
            puncArray = rowsOfKeysARpunctuation.map {($0 == "ٌ") ? sender.currentTitle! :  sender.currentTitle! + $0}
        }
        /*for button in buttonsArray {
            //let currentTitle = button.currentTitle![1]
            keyTitle = sender.currentTitle! + rowsOfKeysHEpunctuation[index]
            button.setTitle(keyTitle, for: UIControlState.selected)
            button.setTitle(keyTitle, for: UIControlState.normal)
            button.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
            index = index + 1
        }*/
        let halfSize = (puncArray.count/2)
        /*if(sender.currentTitle == "ל"){
            puncArray[5] = KeyboardViewController.lamedForBugSolution
        }*/
        for index in 0...halfSize {
            let currentButton:UIButton = self.buttonsArray[index]
           // if(sender.currentTitle! != currentButton.titleLabel?.text){
                UIView.transition(with: self.buttonsArray[index], duration: 0.2*Double(index), options: [.transitionFlipFromLeft ],
                              animations: {
                                keyTitle1 = puncArray[index]
                                currentButton.setTitle(keyTitle1, for: UIControl.State.selected)
                                currentButton.setTitle(keyTitle1, for: UIControl.State.normal)
                                currentButton.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
                                currentButton.layer.borderColor = UIColor.white.cgColor
                                currentButton.layer.borderWidth = 2
            })
          //  }
            if ((index+halfSize < buttonsArray.count) && (index + halfSize < puncArray.count)){
            let currentHalfButton:UIButton = self.buttonsArray[index+halfSize]
               // if(sender.currentTitle! != currentHalfButton.titleLabel?.text){
                    UIView.transition(with: self.buttonsArray[index+halfSize], duration: 0.2*Double(index), options: [.transitionFlipFromLeft ],
                              animations: {
                                keyTitle2 = puncArray[index+halfSize]
                                currentHalfButton.setTitle(keyTitle2, for: UIControl.State.selected)
                                currentHalfButton.setTitle(keyTitle2, for: UIControl.State.normal)
                                currentHalfButton.addTarget(self, action:#selector(KeyboardViewController.puncPress), for: .touchUpInside)
                                currentHalfButton.layer.borderColor = UIColor.white.cgColor
                                currentHalfButton.layer.borderWidth = 2
                    
            })
              //  }
            }
        
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
