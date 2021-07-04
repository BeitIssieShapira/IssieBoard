//
//  KeyboardView.swift
//  EducKeyboard
//
//  Copyright (c) 2015 sap. All rights reserved.
//

import UIKit
import Foundation

func standardKeyboard() -> Keyboard {
print("init")
    
    

    /*
     ض ص ق ف غ ع ه خ ح ج
     ش س ي ب ل ا ت ن م ك
     ظ ط ذ د ز ر و ة ث
     
     ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩ ٠
     -/:؛)(£&@"
     .،؟!'
     
     ][}{#٪‏^*+=
     -/:؛)(£&@"
     .،؟!'
     ً ٰ ـ ُ ِ َ ّ ٌ ً ٍ ْ
     
     ﷼
     */

    //Sets of arabic letters: Right/Middle/Left
    let languageOrderIndicator = "@"
    
    let customCharSetOneAR : String = " خ ح ج ن م كو ة ث"
    let customCharSetTwoAR : String = " ف غ ع هب ل ا تد ز ر"
    let customCharSetThreeAR : String = "ض ص قش س يظ ط ذ"
    
    //Sets of english letters: Right/Middle/Left
    let customCharSetOneEN : String = "IOPJKLM,."
    let customCharSetTwoEN : String = "RTYUFGHVBN"
    let customCharSetThreeEN : String = "QWEASDZXC"
    
    //Sets of hebrewׄׄׄ letters: Right/Middle/Left
    let customCharSetOneHE : String = "פםןףךלץתצ"
    let customCharSetTwoHE : String = "וטאחיעמנה"
    let customCharSetThreeHE : String = "רקכגדשבסז,."
    //ׁׂ̣ׄ̇                  ˙  ᐧ    ·
    //⍪,̦،，
    let customCharSetOne : String = customCharSetOneEN
    let customCharSetTwo : String = customCharSetTwoEN
    let customCharSetThree : String = customCharSetThreeEN
   
    let arabicLettersButton = "ا ب ج"
    let arabicNumbersButton = "123"//"١٢٣"
    //let spaceKey = Key(.space)
    //spaceKey.setKeyOutput(" ")

let charSetsHE = [customCharSetOneHE,customCharSetTwoHE,customCharSetThreeHE]
let charSetsEN = [customCharSetOneEN,customCharSetTwoEN,customCharSetThreeEN]
let charSetsAR = [customCharSetOneAR,customCharSetTwoAR,customCharSetThreeAR]

    
    let rowsOfKeysAR = [
        [ "ض", "ص", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج"]
        ,
        [ "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك"]
        ,
        [ "ظ", "ط", "ذ", "د", "ز", "ر", "و", "ة", "ث"]
    ]
    /*
let rowsOfKeysARsorted = [
        [ "ض", "ص", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج"]
        ,
        [ "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك"]
        ,
        [ "ظ", "ط", "ذ", "د", "ز", "ر", "و", "ة", "ث"]
    ]*/
    
    
let rowsOfKeysARsorted = [
    ["ا","ب","ت","ث","ج","ح","خ","د","ذ","ر"]
    ,
    ["ز","س","ش","ص","ض","ط","ظ","ع","غ","ف"]
    ,
   ["ق","ك","ل","م","ن","ه","و","ي"]
]
    
let rowsOfKeysHE = [
[ ",", ".", "ק", "ר", "א", "ט", "ו", "ן", "ם", "פ"]
,
    ["ש", "ד", "ג", "כ", "ע", "י", "ח", "ל", "ך", "ף"]
,
            [ "ז", "ס", "ב", "ה", "נ", "מ", "צ", "ת", "ץ"]
]
    
    let rowsOfKeysHEsorted = [
        [ ",", ".", "ח", "ז", "ו", "ה", "ד", "ג", "ב", "א"],
        ["צ", "פ", "ע", "ס", "נ", "מ", "ל", "כ", "י", "ט"],
        [ "ץ", "ף", "ן", "ם", "ך", "ת", "ש", "ר", "ק"]
    ]
let rowsOfKeysEN = [
["Q","W","E","R","T","Y","U","I","O","P"],
["A","S","D","F","G","H","J","K","L"],
["Z","X","C","V","B","N","M",",","."]]
    
let rowsOfKeysENsorted = [
    ["A","B","C","D","E","F","G","H","I","J"],
    ["K","L","M","N","O","P","Q","R","S"],
    ["T","U","V","W","X","Y","Z",",","."]]

    
    var isUpperCase:Bool = false
    var pagesCounter:Int = 0
    var visibleKeys : String = ""
    
    var isSortedABCKeyboard = false
    
    /*var visibleKeys : String = Settings.sharedInstance.visibleKeys
    
    if(visibleKeys.isEmptyOrWhiteSpace)
    {
        visibleKeys = Settings.sharedInstance.allCharsInKeyboard
    }
    */
    let standardKeyboard = Keyboard()
    
    func ifSortedSwitchToSortedKeysArrays(_ rowsOfKeys:[[String]])->[[String]]{
        if(rowsOfKeys == rowsOfKeysHE){
            return rowsOfKeysHEsorted
        }
        else {
            return rowsOfKeys
        }
    }

    func addKeyboardPageByIndexAndAdditionals(_ pageIndex:Int, nextPageIndex:Int,  numbersPageIndex:Int,rowsOfKeys:[[String]], isUpperCase:Bool,isCaseButtonVisible:Bool, oppositeLanguageTitle:String, oppositeLanguagePage:Int?){

        //var setOneRange:CountableRange<Int>//:CountableRange<Int>
        //var setTwoRange//:CountableRange<Int>
        //var setThreeRange//:CountableRange<Int>
        var numOfKeysInCurrentRow:Int
        //if (numOfKeysInCurrentRow % 3 == 0){

        //}
        //var setOnelastKeyIndex = numOfKeysInCurrentRow - 1
        //var setTwolastKeyIndex = numOfKeysInCurrentRow - 1
        //let rowsOfKeysCheckedSort = ifSortedSwitchToSortedKeysArrays(rowsOfKeys)
        let actualRowsInTheProcess = rowsOfKeys
        if isCaseButtonVisible {
            let keyModeChangeCase = Key(.modeChange)
            keyModeChangeCase.setKeyTitle(isUpperCase ? "abc" : "ABC")
            keyModeChangeCase.setPage(pageIndex)
            keyModeChangeCase.toMode = nextPageIndex
            standardKeyboard.addKey(Key(keyModeChangeCase), row: 2, page: pageIndex)
        }
        var index = 0;
        for rowIndex in [0,1,2]{
            index=0
            numOfKeysInCurrentRow =  actualRowsInTheProcess[rowIndex].count
            let (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
            
            /*
             let isMiddleEnabled = !isTwoColorsKeyboard()
            let setThreeRange  = isMiddleEnabled ? 0..<numOfKeysInCurrentRow/3 : 0..<numOfKeysInCurrentRow/2
            let setTwoRange   = isMiddleEnabled ? numOfKeysInCurrentRow/3..<numOfKeysInCurrentRow*2/3 : 0..<0
            let setOneRange = isMiddleEnabled ? numOfKeysInCurrentRow*2/3...numOfKeysInCurrentRow : numOfKeysInCurrentRow/2...numOfKeysInCurrentRow
             */
 /*
            if(isTwoColorsKeyboard()){
                setOneRange   = 0..<numOfKeysInCurrentRow/2
                setTwoRange   = 0..<0
                setThreeRange = numOfKeysInCurrentRow/2...numOfKeysInCurrentRow
            }
*/
            
            for key in actualRowsInTheProcess[rowIndex] {
                var keyModel : Key

                if ((visibleKeys.uppercased()).range(of: key.uppercased()) == nil) {
                    keyModel = Key (.hiddenKey)
                }
                else if (setOneRange.contains(index)) {
                    keyModel = Key(.customCharSetOne)
                }
                else if (setTwoRange.contains(index)) {
                    keyModel = Key(.customCharSetTwo)
                }
                else if (setThreeRange.contains(index)) {
                    keyModel = Key(.customCharSetThree)
                }
                else {
                    keyModel = Key(.character)
                }
                keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
                keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
                keyModel.setPage(pageIndex)
                standardKeyboard.addKey(keyModel, row: rowIndex, page: pageIndex)
                index += 1
            }
        }
        let backspace = Key(.backspace)
        backspace.setKeyTitle(" ")//fix reader bug
        backspace.setPage(pageIndex)
        standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
        //0 - Hebrew
        //7 - Arabic
        if (pageIndex == 0){
        let togglePunc = Key(.punctuation)
            let punctuationToggleTitle = "ניקוד"
            togglePunc.setKeyTitle(punctuationToggleTitle)
            standardKeyboard.addKey(togglePunc, row: 2, page: pageIndex)
        }
        
        if (pageIndex == 7){
            let togglePunc = Key(.punctuation)
            let punctuationToggleTitle = "التشكيل"
            //"ترقيمٌ"
            togglePunc.setKeyTitle(punctuationToggleTitle)
            standardKeyboard.addKey(togglePunc, row: 2, page: pageIndex)
        }
        let returnKey = Key(.return)
        returnKey.setKeyTitle("⏎")//fix reader bug
        returnKey.setKeyOutput("\n")
        returnKey.setPage(pageIndex)
        standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
        
        let keyModeChangeNumbers = Key(.modeChange)
        keyModeChangeNumbers.setKeyTitle("123")
        if(actualRowsInTheProcess[0][0] == rowsOfKeysAR[0][0]){
            keyModeChangeNumbers.setKeyTitle(arabicNumbersButton)
        }
        keyModeChangeNumbers.toMode = numbersPageIndex
        keyModeChangeNumbers.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeNumbers, row: 3, page: pageIndex)
        
        let keyboardChange = Key(.keyboardChange)
        keyboardChange.setPage(pageIndex)
        standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
        
        let space = Key(.space)
        space.setKeyOutput(" ")
        space.setPage(pageIndex)
        standardKeyboard.addKey(space, row: 3, page: pageIndex)
        
        if let modeChangePage = oppositeLanguagePage{
            let keyModeChangeLanguage = Key(.modeChange)
            keyModeChangeLanguage.setKeyTitle(oppositeLanguageTitle)
            keyModeChangeLanguage.toMode = modeChangePage
            keyModeChangeLanguage.setPage(pageIndex)
            if(oppositeLanguageTitle != ""){
                standardKeyboard.addKey(Key(keyModeChangeLanguage), row: 3, page: pageIndex)
            }
            else{
                standardKeyboard.addKey(Key(keyModeChangeNumbers), row: 3, page: pageIndex)
            }
        }
        
        let dismissKeyboard = Key(.dismissKeyboard)//fix reader bug
        dismissKeyboard.setPage(pageIndex)
        standardKeyboard.addKey(dismissKeyboard, row: 3, page:pageIndex)
    }
    
    func addNumbersPage(_ pageIndex:Int, nextPageIndex:Int, symbolsPageIndex:Int,charSets:[String],undoString:String,prevKeyboardString:String){
        let isArabic = (prevKeyboardString == arabicLettersButton)
        let arrayOfNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        var questionMark = "?"
        if (isArabic){
          //  arrayOfNumbers = ["١", "٢", "٣", "٤", "٥", "٦", "v", "٨", "٩", "٠"]
            questionMark = "؟"
        }
        
        var index = 0
        var numOfKeysInCurrentRow = arrayOfNumbers.count
        var (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
        for key in arrayOfNumbers {
            var keyModel : Key
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (setOneRange.contains(index)) {
                keyModel = Key(.customCharSetOne)
            }
            else if (setTwoRange.contains(index)) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (setThreeRange.contains(index)) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(key)
            keyModel.setKeyOutput(key)
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
            index = index + 1
        }
        var backspace = Key(.backspace)
        backspace = Key(backspace)
        backspace.setKeyTitle("Delete")//fix reader bug
        backspace.setPage(pageIndex)
        //standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
        let arrayOfSecondNumbersPageRow = ["-", "/", ":", ";", "(", ")",(pageIndex<3) ? "₪" : "$", "&", "@"]
        index = 0
        numOfKeysInCurrentRow = arrayOfSecondNumbersPageRow.count
        (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
        for key in arrayOfSecondNumbersPageRow {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (setOneRange.contains(index)) {
                keyModel = Key(.customCharSetOne)
            }
            else if (setTwoRange.contains(index)) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (setThreeRange.contains(index)) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(key)
            keyModel.setKeyOutput(key)
            keyModel.setPage(pageIndex)
            if(prevKeyboardString.range(of: "אבג") != nil){
              if(key == ")"){
                    keyModel.setKeyOutput("(")
                }
                if(key == "("){
                    keyModel.setKeyOutput(")")
                }
            }
            standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
            
            index = index + 1
        }
        
        let returnKey = Key(.return)
        returnKey.setKeyTitle("⏎")//fix reader bug
        returnKey.setPage(pageIndex)
        returnKey.setKeyOutput("\n")
        //standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
        
        
        let keyModeChangeSpecialCharacters = Key(.modeChange)
        keyModeChangeSpecialCharacters.setKeyTitle("#+=")
        keyModeChangeSpecialCharacters.toMode = symbolsPageIndex
        keyModeChangeSpecialCharacters.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeSpecialCharacters, row: 2, page: pageIndex)
 
        let undoKey = Key(.undo)
        undoKey.setKeyTitle(undoString)
        undoKey.setPage(pageIndex)
       // standardKeyboard.addKey(undoKey, row: 2, page: pageIndex)

        let arrayOfThirdNumbersPageRow = [".", ",", questionMark, "!", "'", "\""]
        index = 0
        numOfKeysInCurrentRow =  arrayOfThirdNumbersPageRow.count
        (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
        for key in arrayOfThirdNumbersPageRow {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (setOneRange.contains(index)) {
                keyModel = Key(.customCharSetOne)
            }
            else if (setTwoRange.contains(index)) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (setThreeRange.contains(index)) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(key)
            keyModel.setKeyOutput(key)
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
            
            index = index + 1
        }
        
        //standardKeyboard.addKey(Key(keyModeChangeSpecialCharacters), row: 2, page: pageIndex)
        standardKeyboard.addKey(backspace, row: 2, page: pageIndex)
        let keyModeChangeLetters = Key(.modeChange)
        keyModeChangeLetters.setKeyTitle(prevKeyboardString)
        keyModeChangeLetters.toMode = nextPageIndex
        keyModeChangeLetters.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeLetters, row: 3, page: pageIndex)
        
        let keyboardChange = Key(.keyboardChange)
        keyboardChange.setPage(pageIndex)
        standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
        
        let space = Key(.space)
        space.setKeyOutput(" ")
        space.setPage(pageIndex)
        standardKeyboard.addKey(space, row: 3, page: pageIndex)
        
        //standardKeyboard.addKey(Key(keyModeChangeLetters), row: 3, page: pageIndex)
        standardKeyboard.addKey(returnKey, row: 3, page: pageIndex)
        //orit: add output
        let dismissKeyboard = Key(.dismissKeyboard)
        dismissKeyboard.setPage(pageIndex)
        standardKeyboard.addKey(dismissKeyboard, row: 3, page: pageIndex)
    }
    
    func addSymbolsPage(_ pageIndex:Int, nextPageIndex:Int,charSets:[String],undoString:String,prevKeyboardString:String){
        
    var index = 0
    var arrayOfCurrentRow =  ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
    var numOfKeysInCurrentRow = arrayOfCurrentRow.count
    var (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
    for key in arrayOfCurrentRow {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (setOneRange.contains(index)) {
            keyModel = Key(.customCharSetOne)
        }
        else if (setTwoRange.contains(index)) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (setThreeRange.contains(index)) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }

        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
        
        index = index + 1
    }
    
    var backspace = Key(.backspace)
    backspace = Key(backspace)
    backspace.setPage(pageIndex)
    //standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
    
    arrayOfCurrentRow = ["_", "\\", "|", "~", "<", ">", "$", "€", "£"]
    index = 0
    numOfKeysInCurrentRow =  arrayOfCurrentRow.count
    (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
    for key in arrayOfCurrentRow {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (setOneRange.contains(index)) {
            keyModel = Key(.customCharSetOne)
        }
        else if (setTwoRange.contains(index)) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (setThreeRange.contains(index)) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }

        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
        
        index = index + 1
    }
    
    let returnKey = Key(.return)
    returnKey.setKeyTitle("⏎")//fix reader bug
    returnKey.setPage(pageIndex)
        returnKey.setKeyOutput("\n")
    //standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
    
    let keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.setKeyTitle("123")
    if(charSets[0] == charSetsAR[0]){
        keyModeChangeNumbers.setKeyTitle(arabicNumbersButton)
    }
    keyModeChangeNumbers.toMode = pageIndex - 1;
    keyModeChangeNumbers.setPage(pageIndex)
    standardKeyboard.addKey(keyModeChangeNumbers, row: 2, page: pageIndex)

    arrayOfCurrentRow = [".", ",", "?", "!", "'", "•"]
    index = 0
    numOfKeysInCurrentRow =  arrayOfCurrentRow.count
    (setOneRange,setTwoRange,setThreeRange) = getRangesOfSetInRow(numOfKeysInCurrentRow)
        
    for key in arrayOfCurrentRow {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (setOneRange.contains(index)) {
            keyModel = Key(.customCharSetOne)
        }
        else if (setTwoRange.contains(index)) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (setThreeRange.contains(index)) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }
        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(2)
        standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
        
        index = index + 1
    }
    
    standardKeyboard.addKey(backspace, row: 2, page: pageIndex)
        
    var keyModeChangeLetters = Key(.modeChange)
    keyModeChangeLetters.setKeyTitle(prevKeyboardString)
    keyModeChangeLetters.toMode = nextPageIndex
    keyModeChangeLetters.setPage(pageIndex)
        
    keyModeChangeLetters = Key(keyModeChangeLetters)
    keyModeChangeLetters.setPage(pageIndex)
    standardKeyboard.addKey(keyModeChangeLetters,row: 3, page: pageIndex)
    
    let keyboardChange = Key(.keyboardChange)
    keyboardChange.setPage(pageIndex)
    standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
    
    let space = Key(.space)
    space.setKeyOutput(" ")
    space.setPage(pageIndex)
    standardKeyboard.addKey(space, row: 3, page: pageIndex)
    
    //standardKeyboard.addKey(Key(keyModeChangeLetters), row: 3, page: pageIndex)
    standardKeyboard.addKey(returnKey, row: 3, page: pageIndex)
        
    let dismissKeyboard = Key(.dismissKeyboard)
    dismissKeyboard.setPage(pageIndex)
    standardKeyboard.addKey(Key(dismissKeyboard), row: 3, page: pageIndex)
    }

    func createKeyboardLanguageBoth(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         */
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.hebrewLetters.rawValue, nextPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysHE : rowsOfKeysHEsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"abc",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.rawValue)
        
        addNumbersPage(Page.PagesIndex.hebrewNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.hebrewSymbols.rawValue,
                       charSets: charSetsHE,
                       undoString: "בטל",
                       prevKeyboardString: "אבג")
        
        addSymbolsPage(Page.PagesIndex.hebrewSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       charSets: charSetsHE,
                       undoString: "שחזר",
                       prevKeyboardString: "אבג")
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.englishLower.rawValue,
                                             nextPageIndex: Page.PagesIndex.englishUpper.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"אבג",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.rawValue)
        
        addNumbersPage(Page.PagesIndex.englishNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       symbolsPageIndex:Page.PagesIndex.englishSymbols.rawValue,
                       charSets: charSetsEN,
                       undoString: "Undo",
                       prevKeyboardString: "abc")
        
        addSymbolsPage(Page.PagesIndex.englishSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       charSets: charSetsEN,
                       undoString: "Restore",
                       prevKeyboardString: "abc")
        
        addKeyboardPageByIndexAndAdditionals(4,
                                             nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: true,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"אבג",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.rawValue)
        
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if( previousCurrentMode > 6 ){
            KeyboardViewController.setPreviousCurrentMode(0)
        }
    }
    
    func createKeyboardLanguageBothAR_HE(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         
         7 - Arabic
         8 - Numbers
         9 - Symbols
         */
        
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.arabicLetters.rawValue, nextPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysAR : rowsOfKeysARsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"אבג",
                                             oppositeLanguagePage:Page.PagesIndex.hebrewLetters.rawValue)
        
        addNumbersPage(Page.PagesIndex.arabicNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.arabicSymbols.rawValue,
                       charSets: charSetsAR,
                       undoString: "בטל",
                       prevKeyboardString: arabicLettersButton)
        
        addSymbolsPage(Page.PagesIndex.arabicSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       charSets: charSetsAR,
                       undoString: "שחזר",
                       prevKeyboardString: arabicLettersButton)
        
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if( previousCurrentMode > 2 && previousCurrentMode < 7 ){
            KeyboardViewController.setPreviousCurrentMode(7)
        }
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.hebrewLetters.rawValue, nextPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysHE : rowsOfKeysHEsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:arabicLettersButton,
                                             oppositeLanguagePage:Page.PagesIndex.arabicLetters.rawValue)
        
        addNumbersPage(Page.PagesIndex.hebrewNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.hebrewSymbols.rawValue,
                       charSets: charSetsHE,
                       undoString: "בטל",
                       prevKeyboardString: "אבג")
        
        addSymbolsPage(Page.PagesIndex.hebrewSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       charSets: charSetsHE,
                       undoString: "שחזר",
                       prevKeyboardString: "אבג")
        
    }

    
    func createKeyboardLanguageBothAR_EN(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         
         7 - Arabic
         8 - Numbers
         9 - Symbols
         */
        

        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.arabicLetters.rawValue, nextPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysAR : rowsOfKeysARsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"abc",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.rawValue)
        
        addNumbersPage(Page.PagesIndex.arabicNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.arabicSymbols.rawValue,
                       charSets: charSetsAR,
                       undoString: "בטל",
                       prevKeyboardString: arabicLettersButton)
        
        addSymbolsPage(Page.PagesIndex.arabicSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       charSets: charSetsAR,
                       undoString: "שחזר",
                       prevKeyboardString: arabicLettersButton)
        
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if(previousCurrentMode < 3 ){
            KeyboardViewController.setPreviousCurrentMode(7)
        }
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.englishLower.rawValue,
                                             nextPageIndex: Page.PagesIndex.englishUpper.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:arabicLettersButton,
                                             oppositeLanguagePage: Page.PagesIndex.arabicLetters.rawValue)
        
        addNumbersPage(Page.PagesIndex.englishNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       symbolsPageIndex:Page.PagesIndex.englishSymbols.rawValue,
                       charSets: charSetsEN,
                       undoString: "Undo",
                       prevKeyboardString: "abc")
        
        addSymbolsPage(Page.PagesIndex.englishSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       charSets: charSetsEN,
                       undoString: "Restore",
                       prevKeyboardString: "abc")
        
        addKeyboardPageByIndexAndAdditionals(4,
                                             nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: true,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:arabicLettersButton,
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.rawValue)
    }

    
    func createKeyboardLanguageHE(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         */
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.hebrewLetters.rawValue, nextPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.hebrewNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysHE : rowsOfKeysHEsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.rawValue)
        
        addNumbersPage(Page.PagesIndex.hebrewNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.hebrewSymbols.rawValue,
                       charSets: charSetsHE,
                       undoString: "בטל",
                       prevKeyboardString: "אבג")
        
        addSymbolsPage(Page.PagesIndex.hebrewSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.rawValue,
                       charSets: charSetsHE,
                       undoString: "שחזר",
                       prevKeyboardString: "אבג")
        
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if(previousCurrentMode > 2 ){
            KeyboardViewController.setPreviousCurrentMode(0)
        }
    }
    func createKeyboardLanguageEN(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         */
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.englishLower.rawValue,
                                             nextPageIndex: Page.PagesIndex.englishUpper.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.rawValue)
        
        addNumbersPage(Page.PagesIndex.englishNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       symbolsPageIndex:Page.PagesIndex.englishSymbols.rawValue,
                       charSets: charSetsEN,
                       undoString: "Undo",
                       prevKeyboardString: "abc")
        
        addSymbolsPage(Page.PagesIndex.englishSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                       charSets: charSetsEN,
                       undoString: "Restore",
                       prevKeyboardString: "abc")
        
        addKeyboardPageByIndexAndAdditionals(4,
                                             nextPageIndex: Page.PagesIndex.englishLower.rawValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysEN : rowsOfKeysENsorted,
                                             isUpperCase: true,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.rawValue)
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if(previousCurrentMode < 3 || previousCurrentMode > 6){
            KeyboardViewController.setPreviousCurrentMode(3)
        }
    }
    
    func createKeyboardLanguageAR(){
        /*
         Keyboard Pages
         0 - Hebrew
         1 - Numbers
         2 - Symbols
         3 - English Lower
         4 - English Upper
         5 - Numbers
         6 - Symbols
         
         7 - Arabic
         8 - Numbers
         9 - Symbols
         */
        
        /*
         ض ص ق ف غ ع ه خ ح ج
         ش س ي ب ل ا ت ن م ك
         ظ ط ذ د ز ر و ة ث
         ا ب ج
         ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩ ٠
         */
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.arabicLetters.rawValue, nextPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             numbersPageIndex: Page.PagesIndex.arabicNumbers.rawValue,
                                             rowsOfKeys: (isSortedABCKeyboard == false) ? rowsOfKeysAR : rowsOfKeysARsorted,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.rawValue)
        
        addNumbersPage(Page.PagesIndex.arabicNumbers.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       symbolsPageIndex:Page.PagesIndex.arabicSymbols.rawValue,
                       charSets: charSetsAR,
                       undoString: "בטל",
                       prevKeyboardString: arabicLettersButton)
        
        addSymbolsPage(Page.PagesIndex.arabicSymbols.rawValue,
                       nextPageIndex: Page.PagesIndex.arabicLetters.rawValue,
                       charSets: charSetsAR,
                       undoString: "שחזר",
                       prevKeyboardString: arabicLettersButton)
        
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if(previousCurrentMode < 7 ){
            KeyboardViewController.setPreviousCurrentMode(7)
        }
    }
    
    func isTwoColorsKeyboard()->Bool{
        let currentMidColorAlpha = Settings.sharedInstance.charsetKeysTwoBackgroundColor.cgColor.alpha
        return (currentMidColorAlpha == 0)
    }

    func getRangesOfSetInRow(_ numOfKeysInCurrentRow:Int)->(CountableClosedRange<Int>,CountableRange<Int>,CountableRange<Int>){
        let isMiddleEnabled = !isTwoColorsKeyboard()
        let setThreeRange  = isMiddleEnabled ? 0..<numOfKeysInCurrentRow/3 : 0..<numOfKeysInCurrentRow/2
        let setTwoRange   = isMiddleEnabled ? numOfKeysInCurrentRow/3..<numOfKeysInCurrentRow*2/3 : 0..<0
        let setOneRange = isMiddleEnabled ? numOfKeysInCurrentRow*2/3...numOfKeysInCurrentRow : numOfKeysInCurrentRow/2...numOfKeysInCurrentRow
        
        return (setOneRange,setTwoRange,setThreeRange)
    }
    
    let userDefaults:UserDefaults
        = UserDefaults(suiteName: KeyboardViewController.groupName)!
    
    visibleKeys = userDefaults.string(forKey: "ISSIE_KEYBOARD_VISIBLE_KEYS") ?? ""
    
    if(visibleKeys.isEmptyOrWhiteSpace)
    {
        visibleKeys = Settings.sharedInstance.allCharsInKeyboard
    }
    
    var cLanguage = userDefaults.string(forKey: Constants.KEY_ISSIE_KEYBOARD_LANGUAGES) ?? "EN"
    if(cLanguage.contains(languageOrderIndicator)){
        isSortedABCKeyboard = true
        cLanguage = cLanguage.replacingOccurrences(of: languageOrderIndicator, with: "")
    }
    switch cLanguage {
    case "EN":
        createKeyboardLanguageEN()
    case "HE":
        createKeyboardLanguageHE()
    case "AR":
        createKeyboardLanguageAR()
    case "AR_EN":
        createKeyboardLanguageBothAR_EN()
    case "AR_HE":
        createKeyboardLanguageBothAR_HE()
    case "BOTH":
        createKeyboardLanguageBoth()
    default:
        createKeyboardLanguageEN()
    }
    
    return standardKeyboard
}
