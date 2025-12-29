//
//  IntroViewModel.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//


import Foundation
import Combine

final class IntroViewModel: ObservableObject {
    
    @Published var introSelection: IntroEnum = .intro1
    
    init() {
       
    }
}
