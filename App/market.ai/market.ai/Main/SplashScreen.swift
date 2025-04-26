//
//  SplashScreen.swift
//  market.ai
//
//  Created by Marius Genton on 4/26/25.
//

import SwiftUI
import FirebaseAuth

struct SplashScreen: View {
    @Environment(\.navigationController) var navigationController
    
    private func setup() async {
        guard let currentUser = Auth.auth().currentUser else {
            navigationController.screen = .login
            return
        }
        
        navigationController.screen = .home(user: currentUser)
    }
    
    var body: some View {
        Text("Hello, World!")
            .task { await setup() }
    }
}

#Preview {
    SplashScreen()
}
