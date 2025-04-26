//
//  Settings.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct ProfilePage: View {
    @State private var isDarkMode = true
    
    @State private var portfolio: [Stock] = [
        Stock(name: "Apple", ticker: "AAPL", marketCap: 3872409585350, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png")!),
        Stock(name: "Microsoft", ticker: "MSFT", marketCap: 3133802247084, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png")!),
        Stock(name: "Alphabet", ticker: "GOOGL", marketCap: 1876556400000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png")!),
        Stock(name: "Amazon", ticker: "AMZN", marketCap: 2005630000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png")!),
        Stock(name: "NVIDIA", ticker: "NVDA", marketCap: 2708640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png")!),
        Stock(name: "Berkshire Hathaway", ticker: "BRK.B", marketCap: 1145090000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png")!),
        Stock(name: "Tesla", ticker: "TSLA", marketCap: 917810000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png")!),
        Stock(name: "Meta Platforms", ticker: "META", marketCap: 1448168302087, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png")!),
        Stock(name: "UnitedHealth Group", ticker: "UNH", marketCap: 418640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png")!),
        Stock(name: "Johnson & Johnson", ticker: "JNJ", marketCap: 154580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png")!),
    ]
    
    var body: some View {
        ZStack {
            Color("bgNavy")
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 30) {
                    
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
                    
                    // individual stocks
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Your Portfolio")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("Edit")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(portfolio, id: \.name) { stock in
                                    StockPillFYP(
                                        icon: stock.iconUrl!,
                                        ticker: stock.ticker,
                                        isSelected: false
                                    )
                                }
                            }
                        }
                    }
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Market")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            settingRow(icon: "heart.fill", title: "Favorite Articles")
                            settingRow(icon: "message.badge.filled.fill", title: "Saved Chats")
                        }
                    }
                    
                    // App Settings Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Settings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            settingRow(icon: "lock.fill", title: "Privacy Policy")
                            settingRow(icon: "arrow.backward.circle.fill", title: "Sign Out")
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("Sign out")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("purpleLight"))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private func settingRow(icon: String, title: String) -> some View {
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

