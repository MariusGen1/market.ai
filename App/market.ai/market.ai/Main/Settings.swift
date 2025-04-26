//
//  Settings.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct ProfilePage: View {
    @State private var isDarkMode = true
    
    var body: some View {
        ZStack {
            Color("bgNavy")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 50) {
                
                // Profile Card
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 12) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Max Eisenberg")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                    }
                    Spacer()
                }

                // Account Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        profileRow(icon: "bookmark.fill", title: "Saved Articles")
                        profileRow(icon: "person.2.fill", title: "Following")
                        profileRow(icon: "bell.fill", title: "Notifications")
                    }
                }
                
                // App Settings Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Settings")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        Toggle(isOn: $isDarkMode) {
                            HStack(spacing: 10) {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(.gray)
                                Text("Dark Mode")
                                    .foregroundColor(.white)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        profileRow(icon: "lock.fill", title: "Privacy Policy")
                        profileRow(icon: "arrow.backward.circle.fill", title: "Sign Out")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func profileRow(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)

            Text(title)
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
}

#Preview {
    ProfilePage()
}

