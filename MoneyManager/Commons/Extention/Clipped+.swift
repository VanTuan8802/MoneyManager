//
//  Clipped+.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//


import Foundation
import SwiftUI

extension View {
    var radius8: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var radius9: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 9))
    }
    
    var radius10: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var radius17: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 17))
    }
    
    var radius20: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var radius24: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    var radius100: some View {
        self.clipShape(RoundedRectangle(cornerRadius: 100))
    }
    
    func radius(topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, bottomTrailing: CGFloat = 0, topTrailing: CGFloat = 0) -> some View {
        self.clipShape(
            .rect(topLeadingRadius: topLeading,
                  bottomLeadingRadius: bottomLeading,
                  bottomTrailingRadius: bottomTrailing,
                  topTrailingRadius: topTrailing)
        )
    }
    
    func radius(_ allCorners: CGFloat) -> some View {
        self.clipShape(
            .rect(topLeadingRadius: allCorners,
                  bottomLeadingRadius: allCorners,
                  bottomTrailingRadius: allCorners,
                  topTrailingRadius: allCorners)
        )
    }
    
    func roundedCornerWithBorder(lineWidth: CGFloat = 0,
                                  borderColor: Color = .clear,
                                  radius: CGFloat,
                                  corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
            .overlay(RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor, lineWidth: lineWidth))
    }
}
