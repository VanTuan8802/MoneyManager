//
//  ContainerView.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import SwiftUI
import Factory

struct ContainerView: View {
    
    @State private var isSplashShowing: Bool = true
    @State private var isFirstLaunch: Bool = true
    @InjectedObject(\.app) private var app: AppManager
    
    @StateObject private var login = Navigation()
    
    @State private var didSetupFirstLanguage: Bool = FirstFlowStorage.shared.didSetupFirstLanguage {
        didSet {
            FirstFlowStorage.shared.didSetupFirstLanguage = didSetupFirstLanguage
        }
    }
    
    @State private var didFinishIntroduction: Bool = FirstFlowStorage.shared.didFinishIntroduction {
        didSet {
            FirstFlowStorage.shared.didFinishIntroduction = didFinishIntroduction
        }
    }
    
    @State private var didSelectCurrency: Bool = FirstFlowStorage.shared.didSelectCurrency {
        didSet {
            FirstFlowStorage.shared.didSelectCurrency = didSelectCurrency
        }
    }
    

    @State private var didSetBudget: Bool = FirstFlowStorage.shared.didSetBudget {
        didSet {
            FirstFlowStorage.shared.didSetBudget = didSetBudget
        }
    }
    
    var body: some View {
        contentView
            .onAppear {
                if CurrencyManager.shared.currencies.isEmpty {
                    CurrencyManager.shared.getCurrency()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                guard !isFirstLaunch, !isSplashShowing else { return }
            }
    }
    
    @ViewBuilder @MainActor
    private var contentView: some View {
        Group {
            if isSplashShowing {
                SplashView(
                    onCompleted: {
                        withAnimation {
                            isSplashShowing = false
                            isFirstLaunch = false
                        }
                    }
                )
            } else if !didSetupFirstLanguage {
                LanguageView(
                    isFirstLanguage: true,
                    onCompleted: {
                        withAnimation {
                            didSetupFirstLanguage = true
                        }
                    }
                )
            } else if !didFinishIntroduction {
                IntroView(
                    onCompleted: {
                        withAnimation {
                            didFinishIntroduction = true
                        }
                    }
                )
            } else if !didSelectCurrency {
                CurrencyView(
                    currencySelected: .default(),
                    isFullScreen: true,
                    onCompleted: {
                        withAnimation {
                            didSelectCurrency = true
                        }
                    }
                )
            } else {
                SetBudgetView(onCompleted: {
                    withAnimation {
                        didSetBudget = true
                    }
                })
            }
//            } else if !didFisishLogin {
//                LoginView(
//                    onCompleted: {
//                        withAnimation {
//                            didFisishLogin = true
//                        }
//                    }
//                )
//                .onAppear {
//                    app.navi = login
//                }
//            } else if !didSelectCurrency {
//                BaseCurrencyView(
//                    currencySelected: .default(),
//                    isFullScreen: true,
//                    onCompleted: {
//                        withAnimation {
//                            didSelectCurrency = true
//                        }
//                    }
//                )
//            } else if !didSetBudget{
//                SetBudgetView(onCompleted: {
//                    withAnimation {
//                        didSetBudget = true
//                    }
//                })
//            } else {
//                TabBarView()
//            }
        }
    }
}

#Preview {
    ContainerView()
}
