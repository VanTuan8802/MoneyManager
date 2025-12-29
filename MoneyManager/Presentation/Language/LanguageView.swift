//
//  LanguageView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI
import Factory

struct LanguageView: View {
    @InjectedObject(\.app) internal var app: AppManager
    private var onCompleted: ( () -> Void)? = nil
    
    @StateObject var viewModel: LanguageViewModel
    
    @State private var selectedLanguage: LanguageEnum = LanguageStorage.shared.language
    
    init(isFirstLanguage: Bool, onCompleted: (() -> Void)?) {
        _viewModel = StateObject(wrappedValue: LanguageViewModel(isFirstLanguage: isFirstLanguage))
        self.onCompleted = onCompleted
    }
    
    var body: some View {
        AppBackgroundView(
            content: {
                VStack {
                    headerView
                    languageSelectionScrollView
                }
            })
    }
    
    @MainActor @ViewBuilder
    private var headerView: some View {
        BasicHeaderView(
            leadingAction: viewModel.isFirstLanguage ? nil : {
                app.navi.pop()
            },
            title: String(localized:.language),
            trailingImage: Image(.iconDone),
            trailingAction: {
                LanguageStorage.shared.language = selectedLanguage
                if viewModel.isFirstLanguage {
                    onCompleted?()
                }
            },
            showBack: !viewModel.isFirstLanguage
        )
    }
    
    @MainActor @ViewBuilder
    private var languageSelectionScrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(LanguageEnum.allCases, id: \.self) { language in
                    languageItem(for: language)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .background(.cFFFFFF)
        .radius(topLeading: 20, topTrailing: 20)
    }
    
    @MainActor @ViewBuilder
    private func languageItem(for language: LanguageEnum) -> some View {
        Button(action: {
            selectedLanguage = language
        }, label: {
            HStack {
                language.getImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Text(language.getName)
                    .font(.regular16)
                    .foregroundColor(selectedLanguage == language ? .cFFFFFF : .c000000)
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(selectedLanguage == language ? .c2D5163 : .cFFFFFF)
            .radius20
            .roundedCornerWithBorder(
                lineWidth: 1,
                borderColor: selectedLanguage == language ? Color.c2D5163 : .c000000,
                radius: 20
            )
        })
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    LanguageView(isFirstLanguage: true, onCompleted: {})
}
