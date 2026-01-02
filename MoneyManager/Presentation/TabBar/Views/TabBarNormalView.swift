//
//  TabBarNormalView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//


import SwiftUI
import Lottie
import Factory

struct TabBarNormalView: View {
    @Binding var selectedTab: TabBarItem
    @Binding var showOverlay: Bool
    var onSelect: ((TabBarItem) -> Void)?
    var onAddTap: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.white
                .frame(height: 73)
            
            HStack(spacing: 0) {
                TabBarNormalItemView(item: .home, selectedItem: $selectedTab)
                    .onTapGesture { select(.home) }
                
                Spacer()
                
                TabBarNormalItemView(item: .statistic, selectedItem: $selectedTab)
                    .onTapGesture { select(.statistic) }
                
                Spacer()
                    .frame(width: 40)
                
                TabBarNormalItemView(item: .budget, selectedItem: $selectedTab)
                    .onTapGesture { select(.budget) }
                
                Spacer()
                
                TabBarNormalItemView(item: .setting, selectedItem: $selectedTab)
                    .onTapGesture { select(.setting) }
            }
            .frame(height: 73)
            .padding(.horizontal, 16)
            
            Image(.addTransaction)
                .offset(y: -25)
                .onTapGesture {
                    onAddTap?()
                }
        }
    }
    
    private func select(_ tab: TabBarItem) {
        if selectedTab != tab {
            onSelect?(tab)
            selectedTab = tab
        }
    }
}

struct TabBarNormalItemView: View {
    let item: TabBarItem
    @Binding var selectedItem: TabBarItem
    
    var isSelected: Bool {
        item == selectedItem
    }
    
    var body: some View {
        VStack(spacing: 4) {
            (isSelected ? item.iconSelected : item.iconNormal)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(item.title)
                .font(.medium12)
                .foregroundColor(isSelected ? .c2D5163 : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}
