
import Foundation

var counter = 0

class Keyboard {
    var pages: [Page]
    
    init() {
        self.pages = []
    }
    
    func addKey(_ key: Key, row: Int, page: Int) {
        if self.pages.count <= page {
            for _ in self.pages.count...page {
                self.pages.append(Page())
            }
        }
        
        self.pages[page].addKey(key, row: row)
    }
}

class Page {
    var rows: [[Key]]
    
    init() {
        self.rows = []
    }
    
    func addKey(_ key: Key, row: Int) {
        if self.rows.count <= row {
            for _ in self.rows.count...row {
                self.rows.append([])
            }
        }
        
        self.rows[row].append(key)
    }
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
    enum PagesIndex : Int {
        case hebrewLetters = 0
        case hebrewNumbers
        case hebrewSymbols
        case englishLower
        case englishUpper
        case englishNumbers
        case englishSymbols
        case arabicLetters
        case arabicNumbers
        case arabicSymbols
    }
}

class Key: Hashable {
    enum KeyType {
        case character
        case backspace
        case modeChange
        case keyboardChange
        case space
        case shift
        case `return`
        case undo
        case restore
        case dismissKeyboard
        case customCharSetOne
        case customCharSetTwo
        case customCharSetThree
        case specialKeys
        case hiddenKey
        case punctuation
        case other
    }
    
    var type: KeyType
    var keyTitle : String?
    var keyOutput : String?
    var pageNum: Int
    var toMode: Int? //if type is ModeChange toMode holds the page it links to
    var hasOutput : Bool {return (keyOutput != nil)}
    var hasTitle : Bool {return (keyTitle != nil)}
    
    
    var isCharacter: Bool {
        get {
            switch self.type {
            case
            .character,
            .customCharSetOne,
            .customCharSetTwo,
            .customCharSetThree,
            .hiddenKey,
            .specialKeys:
                return true
            default:
                return false
            }
        }
    }
    
    var isSpecial: Bool {
        get {
            switch self.type {
            case
            .backspace,
            .modeChange,
            .keyboardChange,
            .space,
            .punctuation,
            .shift,
            .dismissKeyboard,
            .return,
            .undo,
            .restore :
                return true
            default:
                return false
            }
        }
    }
    
    var hashValue: Int
    
    init(_ type: KeyType) {
        self.type = type
        self.hashValue = counter
        counter += 1
        pageNum = -1
    }
    
    convenience init(_ key: Key) {
        self.init(key.type)
        self.keyTitle = key.keyTitle
        self.keyOutput = key.keyOutput
        self.toMode = key.toMode
        self.pageNum = key.getPage()
    }
    
    func setKeyTitle(_ keyTitle: String) {
        self.keyTitle = keyTitle
    }
    
    func getKeyTitle () -> String {
        if (keyTitle != nil) {
            return keyTitle!
        }
        else {
            return ""
        }
    }
    
    func setKeyOutput(_ keyOutput: String) {
        self.keyOutput = keyOutput
    }
    
    func getKeyOutput () -> String {
        if (keyOutput != nil) {
            return keyOutput!
        }
        else {
            return ""
        }
    }
    
    func setPage(_ pageNum : Int) {
        self.pageNum = pageNum
    }
    
    func getPage() -> Int {
        return self.pageNum
    }
    
}

func ==(lhs: Key, rhs: Key) -> Bool {
    return lhs.hashValue == rhs.hashValue
}



