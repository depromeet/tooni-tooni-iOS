//
//  Fonts.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/24.
//

import UIKit

enum CustomFont {
    case bold
    case medium
    case regular
    case point
    
    var name: String {
        switch self {
        case .bold: return "NotoSansKR-Bold"
        case .medium: return "NotoSansKR-Medium"
        case .regular: return "NotoSansKR-Regular"
        case .point: return "Montserrat-Bold"
        }
    }
    
}

let kPOINT_BOLD_32 =                        UIFont(name: CustomFont.point.name, size: 32.0)
let kPOINT_BOLD_24 =                        UIFont(name: CustomFont.point.name, size: 24.0)

let kHEADING1_BOLD =                        UIFont(name: CustomFont.bold.name, size: 32.0)

let kHEADING2_BOLD =                        UIFont(name: CustomFont.bold.name, size: 24.0)

let kHEADING3_BOLD =                        UIFont(name: CustomFont.bold.name, size: 20.0)

let kHEADING4_BOLD =                        UIFont(name: CustomFont.bold.name, size: 18.0)
let kHEADING4_REGULAR =                     UIFont(name: CustomFont.regular.name, size: 32)

let kBODY1_BOLD =                           UIFont(name: CustomFont.bold.name, size: 16.0)
let kBODY1_REGULAR =                        UIFont(name: CustomFont.regular.name, size: 16.0)

let kBODY2_MEDIUM =                         UIFont(name: CustomFont.medium.name, size: 14.0)
let kBODY2_REGULAR =                        UIFont(name: CustomFont.regular.name, size: 14.0)

let kCAPTION1_MEDIUM =                      UIFont(name: CustomFont.medium.name, size: 12.0)
let kCAPTION1_REGULAR =                     UIFont(name: CustomFont.regular.name, size: 12.0)

let kCAPTION2_BOLD =                        UIFont(name: CustomFont.bold.name, size: 10.0)
let kCAPTION2_REGULAR =                     UIFont(name: CustomFont.regular.name, size: 10.0)

let kCAPTION3_REGULAR =                     UIFont(name: CustomFont.regular.name, size: 8.0)

