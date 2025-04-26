//
//  OnboardInfo.swift
//  Speedwork
//
//  Created by Max Eisenberg on 3/6/25.
//

import SwiftUI

struct MainInfo: View {
    
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            ZStack {
                Color("bgNavy")
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hey Marius!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Welcome to Marketplace.Ai! Stay ahead with specifically curated news that matters to your stocks, your portfolio, and your next big moves.")
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
                        selectedTab += 1
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if selectedTab > 0 {
                        Button(action: {
                            selectedTab -= 1
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 16)
                                Text("Back")
                            }
                            .foregroundColor(Color("purpleLight"))
                            .font(.system(size: 17, weight: .medium))
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

