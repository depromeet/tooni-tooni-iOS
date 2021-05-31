//
//  StringExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/15.
//

import UIKit

extension String {
    
    func style(changeText: String,
               underLine: Bool? = nil,
               stroke: UIColor? = nil,
               font: UIFont? = nil,
               color: UIColor? = nil,
               bgColor: UIColor? = nil,
               lineSpacing: CGFloat? = nil,
               lineOffset: CGFloat? = nil,
               heightMultiplier: CGFloat? = nil) -> NSAttributedString {
        let range = (self as NSString).range(of: changeText)
        let attributedString = NSMutableAttributedString(string: self)
        
        if let _ = underLine {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: range)
        }
        
        if let stroke = stroke {
            attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: stroke , range: range)
            attributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: 1.0 , range: range)
        }
        
        if let font = font {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font , range: range)
        }
        
        if let color = color {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        }
        
        if let bgColor = bgColor {
            attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: bgColor , range: range)
        }

        if let lineOffset = lineOffset {
            attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: lineOffset , range: range)
        }

        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        if let heightMultiplier = heightMultiplier {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = heightMultiplier
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        return attributedString
    }

}

extension String {

  var transformKorean: String {
    switch self {
    case "MON": return "월요일"
    case "TUE": return "화요일"
    case "WED": return "수요일"
    case "THU": return "목요일"
    case "FRI": return "금요일"
    case "SAT": return "토요일"
    case "SUN": return "일요일"
    default: return ""
    }
  }
}
