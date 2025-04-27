//
//  Main Tab.swift
//  Speedwork
//
//  Created by Max Eisenberg on 3/6/25.
//

import SwiftUI
import FirebaseAuth


private struct NavigationControllerKey: EnvironmentKey {
    static var defaultValue = NavigationController()
}

extension EnvironmentValues {
    var navigationController: NavigationController {
        get { self[NavigationControllerKey.self] }
        set { self[NavigationControllerKey.self] = newValue }
    }
}

class NavigationController: ObservableObject {
    enum Screen {
        case splash
        case login
        case landing(user: User)
        case onboardLiteracy(user: User)
        case onboardStocks(user: User, financialLiteracyLevel: FinancialLiteracyLevel)
        case home(user: User)
    }
    
    @Published var screen = Screen.splash
}

struct FlowController: View {
    @StateObject var navigationController = NavigationController()
    
    var body: some View {
        NavigationStack {
            switch navigationController.screen {
            case .splash:
                SplashScreen()
            case .login:
                Login()
            case .landing(let user):
                WelcomeScreen()
            case .onboardLiteracy(let user):
                OnboardLiteracy()
            case .onboardStocks(let user, _):
                OnboardStocks()
            case .home(let user):
                Home()
            }
        }
        .environment(\.navigationController, navigationController)
    }
}

#Preview {
    FlowController()
}

