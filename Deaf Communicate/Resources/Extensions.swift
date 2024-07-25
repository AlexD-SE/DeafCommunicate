//
//  Extensions.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 3/31/24.
//

import Foundation
import SwiftUI

extension Color{
    
    func determineInt() -> Int{
        if (self == Color.black){
            return 1
        }else if (self == Color.white){
            return 2
        }else if (self == Color.blue){
            return 3
        }else if (self == Color.red){
            return 4
        }else if (self == Color.yellow){
            return 5
        }else if (self == Color.orange){
            return 6
        }else{
            return 7
        }
    }
    
}

extension Int{
    
    func determineColor() -> Color{
        if (self == 1){
            return Color.black
        }else if (self == 2){
            return Color.white
        }else if (self == 3){
            return Color.blue
        }else if (self == 4){
            return Color.red
        }else if (self == 5){
            return Color.yellow
        }else if (self == 6){
            return Color.orange
        }else{
            return Color.green
        }
    }
    
}
