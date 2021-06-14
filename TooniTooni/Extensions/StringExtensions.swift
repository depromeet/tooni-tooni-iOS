//
//  StringExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/15.
//

import UIKit

extension String {
    
    // 앱 버전 가져오기
    var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "-"
        }
        
        return version
    }
    
    // 앱 빌드 가져오기
    var appBuild: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "-"
        }
        
        return version
    }
    
    // 앱 버전 (빌드) 가져오기
    var appLongVersion: String {
        return self.appVersion + " (\(self.appBuild))"
    }

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

    // Site
    var siteShortString: String {
        switch self.lowercased() {
        case "naver":
            return "N"
        case "daum":
            return "D"
        case "kakao":
            return "K"
        default:
            return ""
        }
    }
    
    var siteColor: UIColor {
        switch self.lowercased() {
        case "naver":
            return kNAVER_100
        case "daum":
            return kDAUM_100
        case "kakao":
            return kKAKAO_100
        default:
            return kBLUE_100
        }
    }

    var weekString: String {
        switch self {
        case "MON": return "월"
        case "TUE": return "화"
        case "WED": return "수"
        case "THU": return "목"
        case "FRI": return "금"
        case "SAT": return "토"
        case "SUN": return "일"
        default: return ""
        }
    }

}
