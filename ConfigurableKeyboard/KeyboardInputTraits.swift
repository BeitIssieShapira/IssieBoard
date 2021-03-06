

import Foundation
import QuartzCore
import UIKit

var traitPollingTimer: CADisplayLink?

extension KeyboardViewController {
    
    func addInputTraitsObservers() {
        traitPollingTimer?.invalidate()
        traitPollingTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
}
