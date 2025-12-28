//
//  DataFreshable.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 28/12/25.
//

import Foundation
import Combine

@MainActor
class DataFreshable: ObservableObject {
    @Published var homeRefresh: Bool = false
}

