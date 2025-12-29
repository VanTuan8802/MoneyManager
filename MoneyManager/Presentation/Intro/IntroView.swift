//
//  IntroView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI

struct IntroView: View {
    
    @StateObject var viewModel: IntroViewModel
    private var onCompleted: (() -> Void)?
    
    init(onCompleted: (() -> Void)?) {
        _viewModel = StateObject(wrappedValue: IntroViewModel())
        self.onCompleted = onCompleted
    }
    
    var body: some View {
        TabView(selection: $viewModel.introSelection) {
            ForEach(IntroEnum.allCases, id: \.self) { entity in
                VStack {
                    entity.getImageIntro
                        .resizable()
                        .scaledToFit()
                    
                    bottomView(entity: entity)
                    
                    Spacer()
                }
                .background(Color.white)
                .tag(entity)
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    @MainActor @ViewBuilder
    private func bottomView(entity: IntroEnum) -> some View {
        VStack(spacing: 12) {
            titleView(entity: entity)
            indicator
            actionView
        }
        .padding(.bottom, 13)
        .background(Color.white)
    }
    
    @MainActor @ViewBuilder
    private func titleView(entity: IntroEnum) -> some View {
        VStack(spacing: 8) {
            Text(entity.getTitle)
                .font(.bold20)
                .fontWeight(.semibold)
                .foregroundStyle(.c2D5163)
                .multilineTextAlignment(.center)
            
            Text(entity.getContent)
                .font(.medium14)
                .padding(.horizontal, 16)
                .foregroundColor(.c000000)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }
    
    @MainActor @ViewBuilder
    private var actionView: some View {
        Button(
            action: {
                switch viewModel.introSelection {
                case .intro1: viewModel.introSelection = .intro2
                case .intro2: viewModel.introSelection = .intro3
                case .intro3: viewModel.introSelection = .intro4
                case .intro4: onCompleted?()
                }
            },
            label: {
                Text(viewModel.introSelection.getTextButton)
                    .font(.semibold16)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.c2D5163)
            })
        .padding(.horizontal, 16)
    }
    
    @MainActor @ViewBuilder
    private var indicator: some View {
        HStack(spacing: 8) {
            ForEach(IntroEnum.allCases, id: \.self) { introSelection in
                if introSelection == viewModel.introSelection {
                    Image(.indicatorSelected)
                } else {
                    Image(.indicatorNormal)
                }
            }
        }
    }
}

#Preview {
    IntroView(onCompleted: {
        
    })
}
