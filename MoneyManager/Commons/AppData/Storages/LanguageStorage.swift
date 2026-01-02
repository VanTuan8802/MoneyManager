//
//  LanguageStorage.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import SwiftUI

class LanguageStorage {

    static let shared = LanguageStorage()

    private enum Key: String {
        case language
    }

    @AppStorage(Key.language.rawValue)
    var language: LanguageEnum = .en
}
