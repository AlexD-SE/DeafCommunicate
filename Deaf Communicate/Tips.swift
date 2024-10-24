//
//  Tips.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 10/23/24.
//

import Foundation
import TipKit

let useMicrophoneButtonTipTitle: LocalizedStringKey = "Use Microphone Button Tip Title"
let useMicrophoneButtonTipText: LocalizedStringKey = "Use Microphone Button Tip Text"

struct UseMicrophoneButtonTip: Tip{
    
    @Parameter
    static var firstTimeUsingApp: Bool = false
    
    var rules: [Rule] {
        #Rule(Self.$firstTimeUsingApp) {
            $0 == true
        }
    }
    
    var title: Text {
        Text(useMicrophoneButtonTipTitle)
    }
    
    var message: Text? {
        Text(useMicrophoneButtonTipText)
    }
    
}

let useKeyboardTipTitle: LocalizedStringKey = "Use Keyboard Tip Title"
let useKeyboardTipText: LocalizedStringKey = "Use Keyboard Tip Text"

struct UseKeyboardTip: Tip{
    
    @Parameter
    static var didFinishDictate: Bool = false
    
    @Parameter
    static var firstTimeUsingApp: Bool = false
    
    var rules: [Rule] {
        
        #Rule(Self.$didFinishDictate) {
            $0 == true
        }
        
        #Rule(Self.$firstTimeUsingApp) {
            $0 == true
        }
    }
    
    var title: Text {
        Text(useKeyboardTipTitle)
    }
    
    var message: Text? {
        Text(useKeyboardTipText)
    }
    
}
