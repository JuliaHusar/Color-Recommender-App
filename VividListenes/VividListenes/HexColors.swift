//
//  HexColors.swift
//  VividListenes
//
//  Created by Julia Husar on 4/8/25.
//

import UIKit

//This entire extension is used for converting hex values to something usable by UIKit which we'll need in our UI
extension UIColor {
    convenience init?(hexString: String, alpha: CGFloat = 1.0){
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: " ")
        
        var rgb: UInt64 = 0
        
        //scanner is used
        guard Scanner(string: hex).scanHexInt64(&rgb) else {return nil}
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    
    }
}
