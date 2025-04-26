import SwiftUI

struct OnboardStocks: View {

    @Binding var selectedTab: Int
    
    @State private var stocks: [Stock] = []
    @State private var selectedStocks: [Stock] = []
    
    @State private var searchText: String = ""
    @State private var showSelections: Bool = false

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
                        Button {
                            showSelections.toggle()
                        } label: {
                            if !selectedStocks.isEmpty {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                                        .foregroundStyle(Color("purpleLight"))
                                    Text("\(selectedStocks.count)")
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("purpleLight"))
                                        .padding(.trailing)
                                }
                            }
                        }
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
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    selectedTab -= 1
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color("purpleLight"))
                        Text("Back")
                            .foregroundStyle(Color("purpleLight"))
                            .font(.system(size: 17, weight: .medium, design: .default))
                    }
                }
            }
        }
        .sheet(isPresented: $showSelections) {
            SelectedStocksSheet(selectedStocks: selectedStocks)
                .presentationDetents([.fraction(0.50)])
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
                    print(stocks)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct StockList: View {
    let stocks: [Stock]
    @Binding var searchText: String
    @Binding var selectedStocks: [Stock]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(0..<Int(ceil(Double(stocks.count) / 3.0)), id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(0..<3, id: \.self) { columnIndex in
                            let index = rowIndex * 3 + columnIndex
                            if index < stocks.count {
                                let stock = stocks[index]
                                StockPill(
                                  stock: stock,
                                  selectedStocks: $selectedStocks
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}


struct SelectedStocksSheet: View {
    let selectedStocks: [Stock]
    
    var body: some View {
        
        VStack(alignment: .leading) {

            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 40, height: 5)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .cornerRadius(2.5)
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack {
                Text("Selected Stocks")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 10)
            
            if selectedStocks.isEmpty {
                Spacer()
                Text("You haven't selected any stocks yet.")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 25) {
                        ForEach(0..<Int(ceil(Double(selectedStocks.count) / 3.0)), id: \.self) { rowIndex in
                            HStack(spacing: 20) {
                                ForEach(0..<3, id: \.self) { columnIndex in
                                    let index = rowIndex * 3 + columnIndex
                                    if index < selectedStocks.count {
                                        let stock = selectedStocks[index]
                                        StockPill(stock: stock,
                                                  selectedStocks: .constant([]))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color("bgNavy"))
        .ignoresSafeArea()
    }
}
