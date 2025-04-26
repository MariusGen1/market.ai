import SwiftUI

struct FYP: View {
    @State private var greeting = ""
    @State private var selectedStock: Stock? = nil
    
    @State private var portfolio: [Stock]? = nil
    @State private var feed: [Article]? = nil
    
    private func loadData() async {
        do {
            portfolio = try await UserService.getPortfolio()
            feed = try await NewsService.getArticles()
            print(feed)
        } catch { print(error) }
    }
    
//    @State private var portfolio: [Stock] = [
//        Stock(name: "Apple", ticker: "AAPL", marketCap: 3872409585350, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png")!),
//        Stock(name: "Microsoft", ticker: "MSFT", marketCap: 3133802247084, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png")!),
//        Stock(name: "Alphabet", ticker: "GOOGL", marketCap: 1876556400000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png")!),
//        Stock(name: "Amazon", ticker: "AMZN", marketCap: 2005630000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png")!),
//        Stock(name: "NVIDIA", ticker: "NVDA", marketCap: 2708640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png")!),
//        Stock(name: "Berkshire Hathaway", ticker: "BRK.B", marketCap: 1145090000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png")!),
//        Stock(name: "Tesla", ticker: "TSLA", marketCap: 917810000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png")!),
//        Stock(name: "Meta Platforms", ticker: "META", marketCap: 1448168302087, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png")!),
//        Stock(name: "UnitedHealth Group", ticker: "UNH", marketCap: 418640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png")!),
//        Stock(name: "Johnson & Johnson", ticker: "JNJ", marketCap: 154580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png")!),
//    ]

    var body: some View {
        ZStack {
            Color("bgNavy")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 25) {

                HStack {
                    Text(greeting)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                
                // quick glance
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Glance")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.20))
                        .frame(height: 125)
                        .cornerRadius(15)
                }
                
                // individual stocks
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(portfolio, id: \.name) { stock in
                            StockPillFYP(
                                icon: stock.iconUrl!,
                                ticker: stock.ticker,
                                isSelected: selectedStock?.name == stock.name,
                                onTap: {
                                    selectedStock = stock
                                }
                            )
                        }
                    }
                }

                // specific stock news section
                if let selected = selectedStock {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Stock:")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(selected.name)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            selectedStock = portfolio[0]
            setGreeting()
        }
        .task { await loadData() }
    }

    private func setGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 3..<12:
            greeting = "Good Morning"
        case 12..<18:
            greeting = "Good Afternoon"
        default:
            greeting = "Good Evening"
        }
    }
}

#Preview {
    FYP()
}
