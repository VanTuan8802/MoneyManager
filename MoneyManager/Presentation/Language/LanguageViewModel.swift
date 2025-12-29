//
//  LanguageViewModel.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import Combine

final class LanguageViewModel: ObservableObject {
    @Published var isFirstLanguage: Bool = true
    @Published var isShowToast: Bool = false

    init(isFirstLanguage: Bool) {
        self.isFirstLanguage = isFirstLanguage
    
    }
}
