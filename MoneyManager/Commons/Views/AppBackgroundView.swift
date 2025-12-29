//
//  AppBackgroundView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI

struct AppBackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Image(.appBg)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            content
        }
    }
}

#Preview {
    AppBackgroundView {
        VStack {
            Text("Hello, World!")
                .foregroundColor(.white)
        }
    }
}
