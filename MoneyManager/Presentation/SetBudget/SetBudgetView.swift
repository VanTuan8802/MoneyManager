//
//  SetBudgetView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//

import SwiftUI
import Factory

struct SetBudgetView: View {
    
    @StateObject var viewModel: SetBudgetViewModel
    @InjectedObject(\.app) internal var app: AppManager
    @FocusState private var isAmountFocused: Bool
    
    private var onCompleted: (() -> Void)?
    
    init(onCompleted: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: SetBudgetViewModel())
        self.onCompleted = onCompleted
    }
    
    
    var body: some View {
        VStack(spacing: 44) {
            headerView
            contentView
            inputView
            Spacer()
            actionView
        }
        .ignoresSafeArea(.all)
        .dismissKeyboardOnTap()
    }
    
    @ViewBuilder @MainActor
    private var headerView: some View {
        BasicHeaderView(
            title: String(localized: .setYourBudget),
            titleColor: .c000000
        )
    }
    
    @MainActor @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 16) {
            Image(.budget)
                .frame(width: 154, height: 154)
                .scaledToFill()
                .clipped()
            
            Text(String(localized: .pleaseEnterYourBugget))
                .multilineTextAlignment(.center)
                .font(.medium14)
                .foregroundStyle(.c000000)
        }
        .padding(.horizontal, 40)
    }
    
    @MainActor @ViewBuilder
    private var inputView: some View {
        HStack(spacing: 0) {
            TextField("", text: $viewModel.budget)
                .keyboardType(.numberPad)
                .focused($isAmountFocused)
                .font(.semibold30)
                .foregroundStyle(.c000000)
                .multilineTextAlignment(.center)
                .onChange(of: viewModel.budget) { newValue in
                    let formatted = newValue.toCurrency(locale: Locale.current)
                    if formatted != newValue {
                        viewModel.budget = formatted
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                .placeholder(
                    when: viewModel.budget.isEmpty,
                    placeholder: {
                        Text("0")
                            .font(.semibold30)
                            .foregroundStyle(Color.c000000)
                    }
                )
            
            Text("$")
                .font(.semibold30)
                .foregroundStyle(Color.c000000)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 20)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.c2D5163, lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .contentShape(Rectangle())
        .onTapGesture {
            isAmountFocused = true
        }
    }
    
    @MainActor @ViewBuilder
    private var actionView: some View {
        CustomButton(
            title: String(localized: .save),
            isEnable: $viewModel.isEnable,
            action: {
                onCompleted?()
        })
        .padding(.bottom, 48)
        .padding(.horizontal, 24)
    }
}

#Preview {
    SetBudgetView()
}
