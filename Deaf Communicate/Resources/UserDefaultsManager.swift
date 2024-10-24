//
//  UserDefaultsManager.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/30/24.
//

import Foundation
import SwiftUICore

public class UserDefaultsManager {
    
    public static let shared = UserDefaultsManager()
    
    private init() {}
    
    func loadTextUserDefaults(fontSize: inout Double, fontStyle: inout String, isCustomFontColor: inout Bool, fontColor: inout Color){
        
        if let fontSizeUserDefaultsValue = UserDefaults.standard.object(forKey: "fontSize") as? Double{
            fontSize = fontSizeUserDefaultsValue
        }else{
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
        
        if let fontStyleUserDefaultsValue = UserDefaults.standard.object(forKey: "fontStyle") as? String{
            fontStyle = fontStyleUserDefaultsValue
        }else{
            UserDefaults.standard.set(fontStyle, forKey: "fontStyle")
        }
         
        if let isCustomFontColorUserDefaultsValue = UserDefaults.standard.object(forKey: "isCustomFontColor") as? Bool{
            isCustomFontColor = isCustomFontColorUserDefaultsValue
        }else{
            UserDefaults.standard.set(isCustomFontColor, forKey: "isCustomFontColor")
        }
        
        if let fontColorInt = UserDefaults.standard.object(forKey: "fontColorInt") as? Int{
            fontColor = fontColorInt.determineColor()
        }else{
            UserDefaults.standard.set(fontColor.determineInt(), forKey: "fontColorInt")
        }
    }
    
    func firstTimeUsingApp() -> Bool{
        
        if UserDefaults.standard.object(forKey: "firstTimeUsingApp") is Bool{
            UserDefaults.standard.set(false, forKey: "firstTimeUsingApp")
            return false
        }else{
            UserDefaults.standard.set(true, forKey: "firstTimeUsingApp")
            return true
        }
        
    }
    
}
