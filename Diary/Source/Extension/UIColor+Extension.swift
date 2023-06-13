//  Diary - UIColor+Extension.swift
//  Created by zhilly on 2023/06/13

import UIKit

extension UIColor {
    static func getTextColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return .white
                }
                return .black
            }
        }
        
        return .black
    }
    
    static func getBackgroundColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return .black
                }
                return .white
            }
        }
        
        return .white
    }
}
