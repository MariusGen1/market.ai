//
//  Main Tab.swift
//  Speedwork
//
//  Created by Max Eisenberg on 3/6/25.
//

import SwiftUI

struct OnboardingMain: View {
    
    @State var selectedTab: Int = 2
    
    var body: some View {
        NavigationStack {
            ZStack {
                if selectedTab == 0 {
                    MainInfo(selectedTab: $selectedTab)
                }
                else if selectedTab == 1 {
                    OnboardLiteracy(selectedTab: $selectedTab)
                }
                else if selectedTab == 2 {
                    OnboardStocks(selectedTab: $selectedTab)
                }
            }
        }
    }
}

#Preview {
    OnboardingMain()
}

