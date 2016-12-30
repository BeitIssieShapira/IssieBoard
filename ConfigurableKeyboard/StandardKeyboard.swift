//
//  KeyboardView.swift
//  EducKeyboard
//
//  Created by Bezalel, Orit on 2/27/15.
//  Copyright (c) 2015 sap. All rights reserved.
//

import UIKit
import Foundation

func standardKeyboard() -> Keyboard {
print("init")
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
   
    //let spaceKey = Key(.space)
    //spaceKey.setKeyOutput(" ")

let charSetsHE = [customCharSetOneHE,customCharSetTwoHE,customCharSetThreeHE]
let charSetsEN = [customCharSetOneEN,customCharSetTwoEN,customCharSetThreeEN]
    
let rowsOfKeysHE = [
[ ",", ".", "ק", "ר", "א", "ט", "ו", "ן", "ם", "פ"]
,
    ["ש", "ד", "ג", "כ", "ע", "י", "ח", "ל", "ך", "ף"]
,
            [ "ז", "ס", "ב", "ה", "נ", "מ", "צ", "ת", "ץ"]
]
let rowsOfKeysEN = [
["Q","W","E","R","T","Y","U","I","O","P"],
["A","S","D","F","G","H","J","K","L"],
["Z","X","C","V","B","N","M",",","."]]
    
    var isUpperCase:Bool = false
    var pagesCounter:Int = 0
    var visibleKeys : String = Settings.sharedInstance.visibleKeys
    
    if(visibleKeys.isEmptyOrWhiteSpace)
    {
        visibleKeys = Settings.sharedInstance.allCharsInKeyboard
    }
    
    let standardKeyboard = Keyboard()
    
/*
    func addKeyboardPage(_ pageIndex:Int, isUpperCase:Bool){
    //Page index Start
    for key in rowsOfKeysEN[0] {
        var keyModel : Key
        
        if (visibleKeys.uppercased().range(of: key.uppercased()) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (customCharSetOne.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (customCharSetThree.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }
        
        keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
        keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
    }
    
    let backspace = Key(.backspace)
    backspace.setPage(pageIndex)
    standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
    
    for key in rowsOfKeysEN[1]  {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (customCharSetOne.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (customCharSetThree.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }
        
        keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
        keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
    }
    let keyModeChangeCase = Key(.character)
    keyModeChangeCase.setKeyTitle(isUpperCase ? "abc" : "ABC")
    keyModeChangeCase.setPage(isUpperCase ? 3 : 0)
    keyModeChangeCase.toMode = isUpperCase ? 0 : 3
    standardKeyboard.addKey(Key(keyModeChangeCase), row: 2, page: pageIndex)
    
    for key in rowsOfKeysEN[2]  {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (customCharSetOne.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (customCharSetThree.range(of: key.uppercased()) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }
        
        keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
        keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
    }
    
    let returnKey = Key(.return)
    returnKey.setKeyOutput("\n")
    returnKey.setPage(pageIndex)
    standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
    
    let keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.setKeyTitle(".?123")
    keyModeChangeNumbers.toMode = 1
    keyModeChangeNumbers.setPage(pageIndex)
    standardKeyboard.addKey(keyModeChangeNumbers, row: 3, page: pageIndex)
    
    let keyboardChange = Key(.keyboardChange)
    keyboardChange.setPage(pageIndex)
    standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
    
    
    let space = Key(.space)
    space.setKeyTitle(isUpperCase ? "SPACE" : "space")
    space.setKeyOutput(" ")
    space.setPage(pageIndex)
    standardKeyboard.addKey(space, row: 3, page: pageIndex)
    
    standardKeyboard.addKey(Key(keyModeChangeNumbers), row: 3, page: pageIndex)
    
    let dismissKeyboard = Key(.dismissKeyboard)
    dismissKeyboard.setPage(pageIndex)
    standardKeyboard.addKey(dismissKeyboard, row: 3, page: pageIndex)
}

    func addKeyboardPageByArrayOfRows(_ pageIndex:Int, rowsOfKeys:[[String]]){
        //Page index Start
        for key in rowsOfKeys[0] {
            var keyModel : Key
            
            if (visibleKeys.range(of: key.uppercased()) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (customCharSetOne.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (customCharSetThree.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
        }
        
        let backspace = Key(.backspace)
        backspace.setPage(pageIndex)
        standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
        for key in rowsOfKeys[1]  {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (customCharSetOne.range(of: key) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (customCharSetTwo.range(of: key) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (customCharSetThree.range(of: key) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
        }
        
        for key in rowsOfKeys[2]  {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (customCharSetOne.range(of: key) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (customCharSetTwo.range(of: key) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (customCharSetThree.range(of: key) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
        }
        
        let returnKey = Key(.return)
        returnKey.setKeyOutput("\n")
        returnKey.setPage(pageIndex)
        standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
        
        let keyModeChangeNumbers = Key(.modeChange)
        keyModeChangeNumbers.setKeyTitle(".?123")
        keyModeChangeNumbers.toMode = 1
        keyModeChangeNumbers.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeNumbers, row: 3, page: pageIndex)
        
        let keyboardChange = Key(.keyboardChange)
        keyboardChange.setPage(pageIndex)
        standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
        
        
        let space = Key(.space)
        space.setKeyTitle(isUpperCase ? "SPACE" : "space")
        space.setKeyOutput(" ")
        space.setPage(pageIndex)
        standardKeyboard.addKey(space, row: 3, page: pageIndex)
        
        standardKeyboard.addKey(Key(keyModeChangeNumbers), row: 3, page: pageIndex)
        
        let dismissKeyboard = Key(.dismissKeyboard)
        dismissKeyboard.setPage(pageIndex)
        standardKeyboard.addKey(dismissKeyboard, row: 3, page: pageIndex)
    }
    
    func addKeyboardPageByIndexAndRowsOfKeysAndAdditionals(_ pageIndex:Int, nextPageIndex:Int,  numbersPageIndex:Int,rowsOfKeys:[[String]], charSets:[String],isUpperCase:Bool,isCaseButtonVisible:Bool){
        for key in rowsOfKeys[0] {
            var keyModel : Key
            
            if (visibleKeys.range(of: key.uppercased()) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (charSets[0].range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (charSets[1].range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (charSets[2].range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
        }
        
        let backspace = Key(.backspace)
        backspace.setPage(pageIndex)
        standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
        for key in rowsOfKeys[1]  {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (customCharSetOne.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (customCharSetThree.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(0)
            standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
        }
        if isCaseButtonVisible {
            let keyModeChangeCase = Key(.character)
            keyModeChangeCase.setKeyTitle(isUpperCase ? "abc" : "ABC")
            keyModeChangeCase.setPage(pageIndex)
            keyModeChangeCase.toMode = nextPageIndex
            standardKeyboard.addKey(Key(keyModeChangeCase), row: 2, page: pageIndex)
        }
        for key in rowsOfKeys[2]  {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (customCharSetOne.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (customCharSetTwo.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (customCharSetThree.range(of: key.uppercased()) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(isUpperCase ? key : key.lowercased())
            keyModel.setKeyOutput(isUpperCase ? key : key.lowercased())
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
        }
        
        let returnKey = Key(.return)
        returnKey.setKeyOutput("\n")
        returnKey.setPage(pageIndex)
        standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
        
        let keyModeChangeNumbers = Key(.modeChange)
        keyModeChangeNumbers.setKeyTitle(".?123")
        keyModeChangeNumbers.toMode = numbersPageIndex
        keyModeChangeNumbers.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeNumbers, row: 3, page: pageIndex)
        
        let keyboardChange = Key(.keyboardChange)
        keyboardChange.setPage(pageIndex)
        standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
        
        
        let space = Key(.space)
        space.setKeyTitle("")
        space.setKeyOutput(" ")
        space.setPage(pageIndex)
        standardKeyboard.addKey(space, row: 3, page: pageIndex)
        
        standardKeyboard.addKey(Key(keyModeChangeNumbers), row: 3, page: pageIndex)
        
        let dismissKeyboard = Key(.dismissKeyboard)
        dismissKeyboard.setPage(pageIndex)
        standardKeyboard.addKey(dismissKeyboard, row: 3, page:pageIndex)
    }
    */
    func addKeyboardPageByIndexAndAdditionals(_ pageIndex:Int, nextPageIndex:Int,  numbersPageIndex:Int,rowsOfKeys:[[String]], isUpperCase:Bool,isCaseButtonVisible:Bool, oppositeLanguageTitle:String, oppositeLanguagePage:Int?){

        //var setOneRange:CountableRange<Int>//:CountableRange<Int>
        //var setTwoRange//:CountableRange<Int>
        //var setThreeRange//:CountableRange<Int>
        var numOfKeysInCurrentRow:Int
        //if (numOfKeysInCurrentRow % 3 == 0){

        //}
        //var setOnelastKeyIndex = numOfKeysInCurrentRow - 1
        //var setTwolastKeyIndex = numOfKeysInCurrentRow - 1
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
            numOfKeysInCurrentRow = rowsOfKeys[rowIndex].count //e.g 9,10
            
            let setOneRange   = 0..<numOfKeysInCurrentRow/3
            let setTwoRange   = numOfKeysInCurrentRow/3..<numOfKeysInCurrentRow*2/3
            let setThreeRange = numOfKeysInCurrentRow*2/3...numOfKeysInCurrentRow
            
            for key in rowsOfKeys[rowIndex] {
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
        backspace.setPage(pageIndex)
        standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
                
        let returnKey = Key(.return)
        returnKey.setKeyOutput("\n")
        returnKey.setPage(pageIndex)
        standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
        
        let keyModeChangeNumbers = Key(.modeChange)
        keyModeChangeNumbers.setKeyTitle("123")
        keyModeChangeNumbers.toMode = numbersPageIndex
        keyModeChangeNumbers.setPage(pageIndex)
        standardKeyboard.addKey(keyModeChangeNumbers, row: 3, page: pageIndex)
        
        let keyboardChange = Key(.keyboardChange)
        keyboardChange.setPage(pageIndex)
        standardKeyboard.addKey(keyboardChange, row: 3, page: pageIndex)
        
        let space = Key(.space)
        space.setKeyTitle("")
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
        
        let dismissKeyboard = Key(.dismissKeyboard)
        dismissKeyboard.setPage(pageIndex)
        standardKeyboard.addKey(dismissKeyboard, row: 3, page:pageIndex)
    }
    
    func addNumbersPage(_ pageIndex:Int, nextPageIndex:Int, symbolsPageIndex:Int,charSets:[String],undoString:String,prevKeyboardString:String){
        for key in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (charSets[0].range(of: key) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (charSets[1].range(of: key) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (charSets[2].range(of: key) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(key)
            keyModel.setKeyOutput(key)
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
        }
        var backspace = Key(.backspace)
        backspace = Key(backspace)
        backspace.setPage(pageIndex)
        //standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
        
        
        for key in ["-", "/", ":", ";", "(", ")",(pageIndex<3) ? "₪" : "$", "&", "@"] {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (charSets[0].range(of: key) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (charSets[1].range(of: key) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (charSets[2].range(of: key) != nil) {
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
        }
        
        let returnKey = Key(.return)
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

        for key in [".", ",", "?", "!", "'", "\""] {
            var keyModel : Key
            
            if (visibleKeys.range(of: key) == nil) {
                keyModel = Key (.hiddenKey)
            }
            else if (charSets[0].range(of: key) != nil) {
                keyModel = Key(.customCharSetOne)
            }
            else if (charSets[1].range(of: key) != nil) {
                keyModel = Key(.customCharSetTwo)
            }
            else if (charSets[2].range(of: key) != nil) {
                keyModel = Key(.customCharSetThree)
            }
            else {
                keyModel = Key(.character)
            }
            
            keyModel.setKeyTitle(key)
            keyModel.setKeyOutput(key)
            keyModel.setPage(pageIndex)
            standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
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
    for key in ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="] {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (charSets[0].range(of: key) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (charSets[1].range(of: key) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (charSets[2].range(of: key) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }

        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 0, page: pageIndex)
    }
    
    let backspace = Key(.backspace)
    backspace.setPage(pageIndex)
    //standardKeyboard.addKey(backspace, row: 0, page: pageIndex)
    
    for key in ["_", "\\", "|", "~", "<", ">", "$", "€", "£"] {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (customCharSetOne.range(of: key) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (customCharSetTwo.range(of: key) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (customCharSetThree.range(of: key) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }

        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 1, page: pageIndex)
    }
    
    let returnKey = Key(.return)
    returnKey.setPage(pageIndex)
        returnKey.setKeyOutput("\n")
    //standardKeyboard.addKey(returnKey, row: 1, page: pageIndex)
    
    let keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.setKeyTitle("123")
    keyModeChangeNumbers.toMode = pageIndex - 1;
    keyModeChangeNumbers.setPage(pageIndex)
    standardKeyboard.addKey(keyModeChangeNumbers, row: 2, page: pageIndex)
    /*
    let smileKey = "🙂"
    let restoreKey = Key(.character)
    restoreKey.setKeyTitle(smileKey)
    restoreKey.setPage(pageIndex)
    standardKeyboard.addKey(restoreKey, row: 2, page: pageIndex)
*/
 
    let restoreKey = Key(.restore)
    restoreKey.setKeyTitle(undoString)
    restoreKey.setPage(pageIndex)
    //standardKeyboard.addKey(restoreKey, row: 2, page: pageIndex)

        
/*    var  keyModel = Key(.character)

    keyModel.setKeyTitle("X")
    keyModel.setKeyOutput("X")
    keyModel.setPage(pageIndex)
    standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
        keyModel = Key(.character)
        keyModel.setKeyTitle("X")
        keyModel.setKeyOutput("X")
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
        keyModel = Key(.character)
        keyModel.setKeyTitle("X")
        keyModel.setKeyOutput("X")
        keyModel.setPage(pageIndex)
        standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
  */

    for key in [".", ",", "?", "!", "'", "•"] {
        var keyModel : Key
        
        if (visibleKeys.range(of: key) == nil) {
            keyModel = Key (.hiddenKey)
        }
        else if (customCharSetOne.range(of: key) != nil) {
            keyModel = Key(.customCharSetOne)
        }
        else if (customCharSetTwo.range(of: key) != nil) {
            keyModel = Key(.customCharSetTwo)
        }
        else if (customCharSetThree.range(of: key) != nil) {
            keyModel = Key(.customCharSetThree)
        }
        else {
            keyModel = Key(.character)
        }
        keyModel.setKeyTitle(key)
        keyModel.setKeyOutput(key)
        keyModel.setPage(2)
        standardKeyboard.addKey(keyModel, row: 2, page: pageIndex)
    }
    
    //standardKeyboard.addKey(Key(keyModeChangeNumbers), row: 2, page: pageIndex)
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
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.hebrewLetters.hashValue, nextPageIndex: Page.PagesIndex.hebrewNumbers.hashValue,
                                             numbersPageIndex: Page.PagesIndex.hebrewNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysHE,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"abc",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.hashValue)
        
        addNumbersPage(Page.PagesIndex.hebrewNumbers.hashValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.hashValue,
                       symbolsPageIndex:Page.PagesIndex.hebrewSymbols.hashValue,
                       charSets: charSetsHE,
                       undoString: "בטל",
                       prevKeyboardString: "אבג")
        
        addSymbolsPage(Page.PagesIndex.hebrewSymbols.hashValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.hashValue,
                       charSets: charSetsHE,
                       undoString: "שחזר",
                       prevKeyboardString: "אבג")
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.englishLower.hashValue,
                                             nextPageIndex: Page.PagesIndex.englishUpper.hashValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysEN,
                                             isUpperCase: false,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"אבג",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.hashValue)
        
        addNumbersPage(Page.PagesIndex.englishNumbers.hashValue,
                       nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                       symbolsPageIndex:Page.PagesIndex.englishSymbols.hashValue,
                       charSets: charSetsEN,
                       undoString: "Undo",
                       prevKeyboardString: "abc")
        
        addSymbolsPage(Page.PagesIndex.englishSymbols.hashValue,
                       nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                       charSets: charSetsEN,
                       undoString: "Restore",
                       prevKeyboardString: "abc")
        
        addKeyboardPageByIndexAndAdditionals(4,
                                             nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysEN,
                                             isUpperCase: true,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"אבג",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.hashValue)
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
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.hebrewLetters.hashValue, nextPageIndex: Page.PagesIndex.hebrewNumbers.hashValue,
                                             numbersPageIndex: Page.PagesIndex.hebrewNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysHE,
                                             isUpperCase: false,
                                             isCaseButtonVisible: false,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage:Page.PagesIndex.englishLower.hashValue)
        
        addNumbersPage(Page.PagesIndex.hebrewNumbers.hashValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.hashValue,
                       symbolsPageIndex:Page.PagesIndex.hebrewSymbols.hashValue,
                       charSets: charSetsHE,
                       undoString: "בטל",
                       prevKeyboardString: "אבג")
        
        addSymbolsPage(Page.PagesIndex.hebrewSymbols.hashValue,
                       nextPageIndex: Page.PagesIndex.hebrewLetters.hashValue,
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
        
        addKeyboardPageByIndexAndAdditionals(Page.PagesIndex.englishLower.hashValue,
                                             nextPageIndex: Page.PagesIndex.englishUpper.hashValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysEN,
                                             isUpperCase: false,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.hashValue)
        
        addNumbersPage(Page.PagesIndex.englishNumbers.hashValue,
                       nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                       symbolsPageIndex:Page.PagesIndex.englishSymbols.hashValue,
                       charSets: charSetsEN,
                       undoString: "Undo",
                       prevKeyboardString: "abc")
        
        addSymbolsPage(Page.PagesIndex.englishSymbols.hashValue,
                       nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                       charSets: charSetsEN,
                       undoString: "Restore",
                       prevKeyboardString: "abc")
        
        addKeyboardPageByIndexAndAdditionals(4,
                                             nextPageIndex: Page.PagesIndex.englishLower.hashValue,
                                             numbersPageIndex: Page.PagesIndex.englishNumbers.hashValue,
                                             rowsOfKeys: rowsOfKeysEN,
                                             isUpperCase: true,
                                             isCaseButtonVisible: true,
                                             oppositeLanguageTitle:"",
                                             oppositeLanguagePage: Page.PagesIndex.hebrewLetters.hashValue)
        let previousCurrentMode = KeyboardViewController.getPreviousCurrentMode()
        if(previousCurrentMode < 3 ){
            KeyboardViewController.setPreviousCurrentMode(3)
        }
    }
    var userDefaults:UserDefaults
        = UserDefaults(suiteName: "group.issieshapiro.com.issiboard")!
    let cLanguage = userDefaults.string(forKey: "ISSIE_KEYBOARD_LANGUAGES")!
    switch cLanguage {
    case "EN":
        createKeyboardLanguageEN()
    case "HE":
        createKeyboardLanguageHE()
    case "BOTH":
        createKeyboardLanguageBoth()
    default:
        createKeyboardLanguageEN()
    }
    
    return standardKeyboard
}
