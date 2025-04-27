//
//  login.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/25/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct Login: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .cornerRadius(12)
                .padding(.bottom, 20)
            
            Image(.marketAiLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 145)

            Spacer()
            
            GoogleSignInButton()
        }
        .padding(.vertical, 10)
        .background(Color("bgNavy"))
    }
}


struct GoogleSignInButton: View {
    @Environment(\.navigationController) var navigationController
    
    var body: some View {
        Button(action: {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                if let error {
                    print(error)
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error {
                        print(error)
                        return
                    }
                    
                    if let user = Auth.auth().currentUser {
                        Task { @MainActor in navigationController.screen = .onboardLiteracy(user: user) }
                    } else {
                        print("Something went wrong :(")
                    }
                }
            }
        }) {
            HStack(spacing: 10) {
                Image("google")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Login with Google")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .medium))
            
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(.gray.opacity(0.20))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
}

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}

#Preview {
    Login()
}
