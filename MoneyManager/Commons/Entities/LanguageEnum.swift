//
//  LanguageEnum.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//


import Foundation
import SwiftUI

enum LanguageEnum: String, Encodable, CaseIterable {
    case en = "en"
    case es = "es"
    case fr = "fr"
    case hi = "hi"
    case pt = "pt"
    
    var getName: String {
        switch self {
        case .en:
            return "English"
        case .es:
            return "Spanish"
        case .hi:
            return "Hindi"
        case .fr:
            return "French"
        case .pt:
            return "Portuguese"
        }
    }
    
    var getImage: Image {
        switch self {
        case .en:
            return Image(.english)
        case .es:
            return Image(.spanish)
        case .hi:
            return Image(.hindi)
        case .fr:
            return Image(.french)
        case .pt:
            return Image(.portugeese)
        }
    }
}
