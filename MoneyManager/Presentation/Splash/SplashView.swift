//
//  SplashView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI
import Lottie

struct SplashView: View {
    private var onCompleted: (() -> Void)?
    
    init(onCompleted: (() -> Void)? = nil) {
        self.onCompleted = onCompleted
    }
    
    var body: some View {
        ZStack {
            Image(.splashBg)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                HStack {
                    Text("Money")
                        .font(.extraBold22)
                        .foregroundColor(.c2D5163)
                    
                    Text("Manager")
                        .font(.extraBold22)
                        .foregroundColor(.c000000)
                }
            }
            
            LottieView(animation: .named("animation_splash"))
                .playing()
                .frame(width: 80, height: 80)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 80)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onCompleted?()
            }
        }
    }
}

#Preview {
    SplashView()
}
