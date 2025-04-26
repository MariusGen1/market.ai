import SwiftUI

struct OnboardStocks: View {
    
    @State var selectedStocks: [Ticker] = []
    
    @State var selectedTab: Int = 0
    @State var searchText: String = ""
    
    @State var showSelections: Bool = false
    
    let stocks: [(String, String)] = [
        ("apple.com", "AAPL"),
        ("microsoft.com", "MSFT"),
        ("google.com", "GOOGL"),
        ("amazon.com", "AMZN"),
        ("tesla.com", "TSLA"),
        ("meta.com", "META"),
        ("nvidia.com", "NVDA"),
        ("netflix.com", "NFLX"),
        ("adobe.com", "ADBE"),
        ("paypal.com", "PYPL"),
        ("intel.com", "INTC"),
        ("coca-cola.com", "KO"),
        ("pepsi.com", "PEP"),
        ("visa.com", "V"),
        ("mastercard.com", "MA"),
        ("disney.com", "DIS"),
        ("uber.com", "UBER"),
        ("lyft.com", "LYFT"),
        ("shopify.com", "SHOP"),
        ("airbnb.com", "ABNB")
    ]
    
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
                            Text("Selections")
                                .font(.system(size: 15))
                                .foregroundStyle(selectedStocks.count == 0 ? .gray : .white)
                        }
                    }
                    
                    Text("Select the stocks that match your portfolio. Marketplace will tailor your daily updates to these selections.")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    
                    TextField("",
                              text: $searchText,
                              prompt: Text("Search stocks...").foregroundStyle(.gray))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                .padding()
                .background(.gray.opacity(0.20))
                .cornerRadius(12)
                .padding(.bottom, 10)
                
                // scroll to search result
                StockList(stocks: stocks, searchText: $searchText, selectedStocks: $selectedStocks)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTab += 1
                    }
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
        .sheet(isPresented: $showSelections) {
            SelectedStocksSheet(selectedStocks: selectedStocks)
                .presentationDetents([.fraction(0.50)])
        }
    }
}


struct StockList: View {
    
    let stocks: [(String, String)]
    @Binding var searchText: String
    @Binding var selectedStocks: [Ticker]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 25) {
                    ForEach(0..<stocks.count / 5, id: \.self) { rowIndex in
                        if rowIndex.isMultiple(of: 2) {
                            HStack(spacing: 20) {
                                ForEach(0..<3, id: \.self) { i in
                                    let index = rowIndex * 5 + i
                                    if let stock = safeStock(at: index) {
                                        StockView(domain: stock.0, ticker: stock.1, selectedStocks: $selectedStocks)
                                            .id(stock.1)
                                    }
                                }
                            }
                        } else {
                            HStack(spacing: 20) {
                                Spacer(minLength: 0)
                                ForEach(0..<2, id: \.self) { i in
                                    let index = rowIndex * 5 + 3 + i
                                    if let stock = safeStock(at: index) {
                                        StockView(domain: stock.0, ticker: stock.1, selectedStocks: $selectedStocks)
                                            .id(stock.1)
                                    }
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }
            .onChange(of: searchText) { _, newValue in
                if let match = stocks.first(where: { $0.1.lowercased() == newValue.lowercased() }) {
                    withAnimation {
                        proxy.scrollTo(match.1, anchor: .top)
                    }
                }
            }
        }
    }
    
    private func safeStock(at index: Int) -> (String, String)? {
        guard index < stocks.count else { return nil }
        return stocks[index]
    }
}



struct SelectedStocksSheet: View {
    let selectedStocks: [Ticker]
    
    var body: some View {
        VStack {

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
                    .padding(.bottom, 10)
                Spacer()
            }
            
            if selectedStocks.isEmpty {
                Spacer()
                Text("You haven't selected any stocks yet.")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(selectedStocks, id: \.symbol) { stock in
                            HStack(spacing: 12) {
                                let url = stock.iconUrl
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 27, height: 27)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 27, height: 27)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 27, height: 27)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stock.symbol)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(stock.name)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color("bgNavy"))
        .ignoresSafeArea()
    }
}




#Preview {
    OnboardStocks()
}
