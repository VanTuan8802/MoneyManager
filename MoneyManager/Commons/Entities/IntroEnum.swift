//
//  IntroEnum.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import SwiftUI

enum IntroEnum: String, Encodable, CaseIterable, Equatable {
    case intro1
    case intro2
    case intro3
    case intro4
    
    var getImageIntro: Image {
        switch self {
        case .intro1:
            return Image(.intro1)
        case .intro2:
            return Image(.intro2)
        case .intro3:
            return Image(.intro3)
        case .intro4:
            return Image(.intro4)
        }
    }
    
    var getTitle: String {
        switch self {
        case .intro1:
            return String(localized:.onboardTitle1)
        case .intro2:
            return String(localized:.onboardTitle2)
        case .intro3:
            return String(localized:.onboardTitle3)
        case .intro4:
            return String(localized:.onboardTitle4)
        }
    }
    
    var getContent: String {
        switch self {
        case .intro1:
            return String(localized:.onboardContent1)
        case .intro2:
            return String(localized:.onboardContent2)
        case .intro3:
            return String(localized:.onboardContent3)
        case .intro4:
            return String(localized:.onboardContent4)
        }
    }
    
    var getTextButton: String {
        switch self {
        case .intro1, .intro2, .intro3:
            return String(localized:.next)
        case .intro4:
            return String(localized:.start)
        }
    }
    
}

