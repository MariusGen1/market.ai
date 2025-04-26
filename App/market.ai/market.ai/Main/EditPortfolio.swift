//
//  EditPortfolio.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct EditPortfolio: View {
    
    
    @State private var stocks: [Stock] = []
    @State private var selectedStocks: [Stock] = []
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        ZStack {
            Color("bgNavy").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Your Portfolio")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Text("Select the stocks that match your portfolio. Marketplace will tailor your daily updates to these selections.")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    TextField("", text: $searchText, prompt: Text("Search stocks...").foregroundStyle(.gray))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(.gray.opacity(0.20))
                .foregroundStyle(.white)
                .cornerRadius(12)
                .padding(.bottom, 10)
                
                
                StockList(
                    stocks: stocks.isEmpty ? top50stocks : stocks,
                    searchText: $searchText,
                    selectedStocks: $selectedStocks
                )
                
                Spacer()
                
            }
            .padding()
        }
        .onChange(of: searchText) { _, newTerm in
            guard !newTerm.isEmpty else {
                self.stocks = []
                return
            }
            
            let stockSearcher = StockSearcher()
            stockSearcher.searchStocks(for: newTerm) { result in
                if newTerm != searchText { return }
                
                switch result {
                case .success(let stocks):
                    self.stocks = stocks
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
    }
}

#Preview {
    EditPortfolio()
}
