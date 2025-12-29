//
//  NoDataView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI

struct NoDataView: View {
    var text: String = String(localized: .noData)
    var body: some View {
        VStack {
        
            Text(text)
                .font(.medium14)
                .foregroundStyle(Color.c000000)
        }
    }
}

#Preview {
    NoDataView()
}
