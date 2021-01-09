//
//  ColorExtension.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 4.01.2021.
//

import Foundation
import UIKit

extension UIColor{
    static func toRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    
}
