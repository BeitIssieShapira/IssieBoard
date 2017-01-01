
import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    
    static let groupName = "group.com.issieshapiro.Issieboard"
    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.07
    var keyboard: Keyboard!
    var forwardingView: ForwardingView!
    var layout: KeyboardLayout?
    var heightConstraint: NSLayoutConstraint?
    
    var settingsView: ExtraView?
    
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
    }
     

    func methodOfReceivedNotification(_ notification: Notification){
        //Take Action on Notification
        UserDefaults(suiteName: KeyboardViewController.groupName)!.set("XXX", forKey: "gotNotification")
        UserDefaults(suiteName: KeyboardViewController.groupName)!.synchronize()
        fatalError("NSCoding not supported")
    }
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
        defaults.synchronize()
        defaults = UserDefaults.standard
        //var i : Int = defaults.integerForKey("defaultBackgroundColor")
        defaults.synchronize()
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
        UserDefaults(suiteName: KeyboardViewController.groupName)!.synchronize()
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
            let cLanguage = userDefaults.string(forKey: "ISSIE_KEYBOARD_LANGUAGES")!
            switch cLanguage {
            case "EN":
                return 3
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
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
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
    
    var lastLayoutBounds: CGRect?
    override func viewDidLayoutSubviews() {
        if view.bounds == CGRect.zero {
            return
        }
        let interfaceOrientation = self.preferredInterfaceOrientationForPresentation
        //self.interfaceOrientation
        self.setupLayout()
        //UIApplication().statusBarOrientation
        let orientationSavvyBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.heightForOrientation(interfaceOrientation, withTopBanner: false))
        
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
        self.keyboardHeight = self.heightForOrientation(interfaceOrientation, withTopBanner: true)
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
        
        self.keyboardHeight = self.heightForOrientation(toInterfaceOrientation, withTopBanner: true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = false
            }
        }
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
                        keyView.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                        
                        switch key.type {
                        case Key.KeyType.keyboardChange:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.advanceTapped(_:)), for: .touchUpInside)
                        case Key.KeyType.backspace:
                            let cancelEvents: UIControlEvents = [UIControlEvents.touchUpInside, UIControlEvents.touchUpInside, UIControlEvents.touchDragExit, UIControlEvents.touchUpOutside, UIControlEvents.touchCancel, UIControlEvents.touchDragOutside]
                
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
                       }
                        
                        if key.type != Key.KeyType.modeChange {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.highlightKey(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
                            keyView.addTarget(self, action: #selector(KeyboardViewController.unHighlightKey(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
                        }
                        
                        if key.type != Key.KeyType.hiddenKey {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.playKeySound), for: .touchDown)
                        }
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
    
    func showPopup(_ sender: KeyboardKey) {
        if sender == self.keyWithDelayedPopup {
            self.popupDelayTimer?.invalidate()
        }
        sender.showPopup()
    }
    
    func hidePopupDelay(_ sender: KeyboardKey) {
        self.popupDelayTimer?.invalidate()
        
        if sender != self.keyWithDelayedPopup {
            self.keyWithDelayedPopup?.hidePopup()
            self.keyWithDelayedPopup = sender
        }
        
        if sender.popup != nil {
            self.popupDelayTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(KeyboardViewController.hidePopupCallback), userInfo: nil, repeats: false)
        }
    }
    
    func hidePopupCallback() {
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
    
    func highlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = true
    }
    
    func unHighlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = false
    }
    
    func keyPressedHelper(_ sender: KeyboardKey) {
        if let model = self.layout?.keyForView(sender) {
            self.keyPressed(model)

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
                
                if previousContext == nil || (previousContext!).characters.count < 3 {
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
    
    func backspaceDown(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
        
   //     if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            self.textDocumentProxy.deleteBackward()
   //     }

        self.backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceDelayCallback), userInfo: nil, repeats: false)
    }
    
    func backspaceUp(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
    }
    
    func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceRepeatCallback), userInfo: nil, repeats: true)
    }
    
    func backspaceRepeatCallback() {
        self.playKeySound()
        
      //  if let textDocumentProxy = self.textDocumentProxy as? UIKeyInput {
            self.textDocumentProxy.deleteBackward()
      //  }
    }
    
    func dismissKeyboardTapped (_ sender : KeyboardKey) {
        self.dismissKeyboard()
    }
    
    func undoTapped (_ sender : KeyboardKey) {
    }
 
    
    func modeChangeTapped(_ sender: KeyboardKey) {
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
    
    func advanceTapped(_ sender: KeyboardKey) {
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
            for char in (string!).characters {
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
    
    func keyPressed(_ key: Key) {
       // if let proxy = (self.textDocumentProxy as? UIKeyInput) {
            self.textDocumentProxy.insertText(key.getKeyOutput())
       // }
    }
}
