//
//  OnboardInfo.swift
//  Speedwork
//
//  Created by Max Eisenberg on 3/6/25.
//

import SwiftUI
import FirebaseAuth

struct MainInfo: View {
    @Environment(\.navigationController) var navigationController
    @Environment(\.user) var user

    var body: some View {
        NavigationView {
            ZStack {
                Color("bgNavy")
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hey \(user!.displayName!.split(separator: " ")[0])!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Welcome to market.ai! Stay ahead with specifically curated news that matters to your stocks, your portfolio, and your next big moves.")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)

                    }

                    Spacer()
                    
                    HStack {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .cornerRadius(12)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                    
                    Spacer()

                    Button(action: {
                        navigationController.screen = .login
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("purpleLight"))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
        }
    }
}

