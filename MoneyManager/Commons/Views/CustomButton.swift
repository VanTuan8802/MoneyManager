//
//  CustomButton.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    @Binding var isEnable: Bool
    var action: () -> Void
    
    var body: some View {
        Button(
            action: {
                if isEnable {
                    action()
                }
            },
            label: {
                Text(title)
                    .font(.medium14)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background( isEnable ? Color.c2D5163 : Color.gray)
                    .cornerRadius(10)
            }
        )
        .disabled(!isEnable)
    }
}

