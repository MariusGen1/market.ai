import SwiftUI

struct OnboardStocks: View {
    
    
    @State var selectedTab: Int = 0
    @State var searchText: String = ""

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
                    Text("Your Portfolio")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

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
                StockList(stocks: stocks, searchText: $searchText)

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
    }
}


struct StockList: View {
    
    let stocks: [(String, String)]
    @Binding var searchText: String

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
                                        StockView(domain: stock.0, ticker: stock.1)
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
                                        StockView(domain: stock.0, ticker: stock.1)
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


#Preview {
    OnboardStocks()
}
