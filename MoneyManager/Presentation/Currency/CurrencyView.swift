//
//  CurrencyView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI
import Kingfisher
import Factory

struct CurrencyView: View {
    @InjectedObject(\.app) internal var app: AppManager
    
    @StateObject var viewModel: CurrencyViewModel
    private var onCompleted: (() -> Void)?
    
    init(currencySelected: Currency,
         isFullScreen: Bool,
         onCompleted: (() -> Void)?) {
        _viewModel = StateObject(wrappedValue: CurrencyViewModel(isFullScreen: isFullScreen,
                                                                 currencySelected: currencySelected))
        self.onCompleted = onCompleted
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    headerView
                    searchView
                }
                contentView
            }
            NoDataView()
                .opacity(viewModel.renderFavorites.isEmpty && viewModel.renderCurrencies.isEmpty ? 1 : 0)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder @MainActor
    private var headerView: some View {
        BasicHeaderView(
            title:  String(localized: .currencies),
            titleColor: .c000000,
            trailingImage: Image(.iconDone),
            trailingAction: {
                onCompleted?()
            },
            trailingImageColor: .c2D5163,
            isFullScreen: viewModel.isFullScreen,
            showBack: false
        )
    }
    
    @ViewBuilder
    private var searchView: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $viewModel.searchText)
                .onChange(of: viewModel.searchText, perform: { text in
                    viewModel.search(with: text)
                })
                .placeholder(
                    when: viewModel.searchText.isEmpty,
                    placeholder: {
                        Text(String(localized: .search))
                            .font(.medium14)
                            .foregroundStyle(Color.c000000)
                    })
                .font(.medium14)
                .padding(.all, 12)
                .background(Color.c2D5163)
                .radius20
                .padding(.horizontal, 16)
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.c000000)
                .offset(x: -28)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        List {
            Section(header: listSectionView(title: String(localized: .favorites))) {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.renderFavorites.enumerated()), id: \.element.id) { index, currency in
                        item(currency: currency, isFavorite: true)
                            .onTapGesture {
                                viewModel.currencySelected = currency
                                app.navi.pop()
                            }
                        if index < viewModel.renderFavorites.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.c2D5163, lineWidth: 1)
                )
                .radius10
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listSectionSeparatorTint(Color.white)
            
            Section(header: listSectionView(title:String(localized: .currencies))) {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.renderCurrencies.enumerated()), id: \.element.id) { index, currency in
                        item(currency: currency)
                            .onTapGesture {
                                viewModel.currencySelected = currency
                                app.navi.pop()
                            }
                        if index < viewModel.renderCurrencies.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.c2D5163, lineWidth: 1)
                )
                .radius10
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listSectionSeparatorTint(Color.white)
        }
        .listStyle(.plain)
        .padding(.horizontal, 16)
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder @MainActor
    private func listSectionView(title: String) -> some View {
        HStack {
            Text(title)
                .font(.medium16)
                .foregroundStyle(Color.black)
            Spacer()
        }
        .background(Color.white)
    }
    
    @ViewBuilder @MainActor
    private func item(currency: Currency, isFavorite: Bool = false) -> some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    flag(currency: currency)
                    
                    Text(currency.code)
                        .font(.semibold16)
                        .foregroundStyle(viewModel.currencySelected == currency ? Color.white : Color.c000000)
                    
                    Text(currency.symbol)
                        .font(.regular16)
                        .foregroundStyle(viewModel.currencySelected == currency ? Color.white : Color.c000000)
                }
                Spacer()
                
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundStyle(Color.c2D5163)
                        .frame(width: 18, height: 16)
                        .onTapGesture {
                            viewModel.unfavoriteToggled(currency)
                        }
                } else {
                    Image(systemName: "heart")
                        .resizable()
                        .foregroundStyle(Color.c2D5163)
                        .frame(width: 18, height: 16)
                        .onTapGesture {
                            viewModel.favoriteToggled(currency)
                        }
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 12)
            .background(
                viewModel.currencySelected == currency
                ? .c2D5163 : .cFFFFFF
            )
        }
    }
    
    @ViewBuilder @MainActor
    func flag(currency: Currency) -> some View {
        KFImage(URL(string: currency.flag))
            .resizable()
            .placeholder {
                ProgressView()
            }
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
    
    private func getCorners(currency: Currency, isFavorite: Bool) -> UIRectCorner {
        let currencies: [Currency] = {
            if isFavorite {
                return viewModel.renderFavorites
            } else {
                return viewModel.renderCurrencies
            }
        }()
        
        if currencies.count == 1 {
            return .allCorners
        } else if currency == currencies.first {
            return [.topLeft, .topRight]
        } else if currency == currencies.last {
            return [.bottomLeft, .bottomRight]
        } else {
            return []
        }
    }
}

#Preview {
    CurrencyView(currencySelected: .default(), isFullScreen: true, onCompleted: {
        
    })
}
