//
//  XMColor.swift
//  API
//
//  Created by 郭建斌 on 16/5/26.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

extension UIColor
{
    func randColor() -> UIColor {
        
        let r = CGFloat(arc4random_uniform(256));
        
        let g = CGFloat(arc4random_uniform(256));
        
        let b = CGFloat(arc4random_uniform(256));
        
        return UIColor.init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1.0);
        
    }
    
    func colorWithHexString(hexString:String, alpha :CGFloat) -> UIColor {
        
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.clearColor()}
        
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        
        if cString.characters.count != 6 {return UIColor.clearColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}