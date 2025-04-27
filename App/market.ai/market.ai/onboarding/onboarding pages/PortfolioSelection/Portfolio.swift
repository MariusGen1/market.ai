//
//  Portfolio.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct Portfolio: View {
    
    @Binding var selectedStocks: [Stock]
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Top pull bar
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 40, height: 5)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .cornerRadius(2.5)
                Spacer()
            }
            .padding(.top, 10)
            
            // Title
            HStack {
                Text("Your Portfolio")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            // Content
            if selectedStocks.isEmpty {
                VStack(spacing: 12) {
                    Text("No stocks selected yet")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("Pick your favorites to build your portfolio.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.7))
                    Spacer()
                }
                .padding(.vertical, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0..<Int(ceil(Double(selectedStocks.count) / 3.0)), id: \.self) { rowIndex in
                            HStack(spacing: 16) {
                                ForEach(0..<3, id: \.self) { columnIndex in
                                    let index = rowIndex * 3 + columnIndex
                                    if index < selectedStocks.count {
                                        let stock = selectedStocks[index]
                                        StockPill(stock: stock, selectedStocks: $selectedStocks)
                                    } else {
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .background(Color("bgNavy"))
        .ignoresSafeArea()
    }
}

#Preview {
    Portfolio(selectedStocks: .constant([]))
}
