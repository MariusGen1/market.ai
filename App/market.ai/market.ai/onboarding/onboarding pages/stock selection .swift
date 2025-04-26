import SwiftUI

struct OnboardStocks: View {

    @State private var stocks: [Ticker] = []
    @State private var selectedStocks: [Ticker] = []
    
    @State private var selectedTab: Int = 0
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
                            Text("Selections")
                                .font(.system(size: 15))
                                .foregroundStyle(selectedStocks.isEmpty ? .gray : .white)
                        }
                        .disabled(selectedStocks.isEmpty)
                    }
                    Text("Select the stocks that match your portfolio. Marketplace will tailor your daily updates to these selections.")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    TextField("", text: $searchText, prompt: Text("Search stocks...").foregroundStyle(.white))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(.gray.opacity(0.20))
                .cornerRadius(12)
                .padding(.bottom, 10)
                
                StockList(
                    stocks: stocks,
                    searchText: $searchText,
                    selectedStocks: $selectedStocks
                )
                
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
        .onChange(of: searchText) { _, newTerm in
            fetchTickers(for: newTerm, apiKey: "Nr5wXB7hsyVNN_M4sLiakJdIIexXy61j") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetched):
                        stocks = fetched
                    case .failure:
                        stocks = []
                    }
                }
            }
        }
    }
}

struct StockList: View {
    let stocks: [Ticker]
    @Binding var searchText: String
    @Binding var selectedStocks: [Ticker]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(Array(stride(from: 0, to: stocks.count, by: 5)), id: \.self) { start in
                    let end = min(start + 5, stocks.count)
                    let block = Array(stocks[start..<end])
                    
                    HStack(spacing: 20) {
                        ForEach(block.prefix(3), id: \.symbol) { stock in
                            StockView(icon: stock.iconUrl,
                                      ticker: stock.symbol,
                                      selectedStocks: $selectedStocks)
                                .id(stock.symbol)
                        }
                    }
                    
                    if block.count > 3 {
                        HStack(spacing: 20) {
                            Spacer()
                            ForEach(block.dropFirst(3), id: \.symbol) { stock in
                                StockView(icon: stock.iconUrl,
                                          ticker: stock.symbol,
                                          selectedStocks: $selectedStocks)
                                    .id(stock.symbol)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}

struct SelectedStocksSheet: View {
    let selectedStocks: [Ticker]
    
    var body: some View {
        VStack {
            // grabber
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 40, height: 5)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .cornerRadius(2.5)
                Spacer()
            }
            .padding(.bottom, 10)
            
            // title
            HStack {
                Text("Selected Stocks")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 10)
            
            // empty state
            if selectedStocks.isEmpty {
                Spacer()
                Text("You haven't selected any stocks yet.")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            } else {
                // list of picks
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(selectedStocks, id: \.symbol) { stock in
                            HStack(spacing: 12) {
                                AsyncImage(url: stock.iconUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 27, height: 27)
                                    case .success(let img):
                                        img.resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 27, height: 27)
                                           .clipShape(RoundedRectangle(cornerRadius: 8))
                                    case .failure:
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

struct OnboardStocks_Previews: PreviewProvider {
    static var previews: some View {
        OnboardStocks()
    }
}
