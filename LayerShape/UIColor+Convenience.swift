//
//  UIColor+Convenience.swift
//  LayerShape
//
//  Created by Paul Jarysta on 11/05/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//


import UIKit

public extension UIColor {
	
	class func convertToUIColor(hex: Int, alpha: Double = 1.0) -> UIColor {
		let red = Double((hex & 0xFF0000) >> 16) / 255.0
		let green = Double((hex & 0xFF00) >> 8) / 255.0
		let blue = Double((hex & 0xFF)) / 255.0
		let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
		return color
	}
	
	class func blue1() -> UIColor {
		return UIColor.convertToUIColor(0x005E7F, alpha: 1.0)
	}
	
	class func blue2() -> UIColor {
		return UIColor.convertToUIColor(0x4CD0FF, alpha: 1.0)
	}
	
	class func blue3() -> UIColor {
		return UIColor.convertToUIColor(0x00BDFF, alpha: 1.0)
	}
	
	class func blue4() -> UIColor {
		return UIColor.convertToUIColor(0x26687F, alpha: 1.0)
	}
	
	class func blue5() -> UIColor {
		return UIColor.convertToUIColor(0x0097CC, alpha: 1.0)
	}
	
	class func blue6() -> UIColor {
		return UIColor.convertToUIColor(0x147FA5, alpha: 1.0)
	}
	
}
