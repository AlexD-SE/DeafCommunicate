//
//  UserDefaultsManager.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/30/24.
//

import Foundation
import SwiftUI

public class UserDefaultsManager {
    
    public static let shared = UserDefaultsManager()
    
    private init() {}
    
    func loadTextUserDefaults(textSize: inout Double, textStyle: inout TextStyle, isCustomTextColor: inout Bool, textColor: inout Color){
        
        if let textSizeUserDefaultsValue = UserDefaults.standard.object(forKey: "textSize") as? Double{
            textSize = textSizeUserDefaultsValue
        }else{
            UserDefaults.standard.set(textSize, forKey: "textSize")
        }
        
        if let textStyleUserDefaultsValue = UserDefaults.standard.object(forKey: "textStyle") as? String{
            textStyle = TextStyle(rawValue: textStyleUserDefaultsValue) ?? .sfProRegular
        }else{
            UserDefaults.standard.set(textStyle.rawValue, forKey: "textStyle")
        }
         
        if let isCustomTextColorUserDefaultsValue = UserDefaults.standard.object(forKey: "isCustomTextColor") as? Bool{
            isCustomTextColor = isCustomTextColorUserDefaultsValue
        }else{
            UserDefaults.standard.set(isCustomTextColor, forKey: "isCustomTextColor")
        }
        
        if let textColorInt = UserDefaults.standard.object(forKey: "textColorInt") as? Int{
            textColor = textColorInt.determineColor()
        }else{
            UserDefaults.standard.set(textColor.determineInt(), forKey: "textColorInt")
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
