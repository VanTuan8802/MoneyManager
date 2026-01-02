//
//  FirstFlowStorage.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import SwiftUI

class FirstFlowStorage {

    static let shared = FirstFlowStorage()

    private enum Key: String {
        case didSelectedLanguage
        case didFinishIntroduction
        case didSelectCurrency
        case didSetBudget
        case didOpenFirstApp
    }

    @AppStorage(Key.didSelectedLanguage.rawValue)
    var didSetupFirstLanguage: Bool = false

    @AppStorage(Key.didFinishIntroduction.rawValue)
    var didFinishIntroduction: Bool = false

    @AppStorage(Key.didSelectCurrency.rawValue)
    var didSelectCurrency: Bool = false

    @AppStorage(Key.didSetBudget.rawValue)
    var didSetBudget: Bool = false

    @AppStorage(Key.didOpenFirstApp.rawValue)
    var didOpenFirstApp: Bool = false
}

