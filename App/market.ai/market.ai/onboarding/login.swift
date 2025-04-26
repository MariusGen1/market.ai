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
    
    @State var isSignedIn: Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("market.ai")
                .font(.title)
                .foregroundStyle(.white)
            
            Spacer()
            
            GoogleSignInButton(isSignedIn: $isSignedIn)
        }
        .background(Color("bgNavy"))
    }
}


struct GoogleSignInButton: View {
    
    @Binding var isSignedIn: Bool
    
    var body: some View {
        Button(action: {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                guard error == nil else { return }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    guard error == nil else { return }
                    
                    if let user = Auth.auth().currentUser { isSignedIn = true }
                    else { isSignedIn = false }
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
