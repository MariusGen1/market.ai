import SwiftUI

struct FYP: View {
    @State private var greeting = ""
    @State private var selectedStock: Stock? = nil
    
    //    @State private var portfolio: [Stock]? = nil
    @State private var feed: [Article]? = nil
    
    
//    private func loadData() async {
//        do {
//            portfolio = try await UserService.getPortfolio()
//            feed = try await NewsService.getArticles()
//        } catch { print(error) }
//    }
    
    @State private var portfolio: [Stock] = [
        Stock(
            name: "Apple",
            ticker: "AAPL",
            marketCap: 3872409585350,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Microsoft",
            ticker: "MSFT",
            marketCap: 3133802247084,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Alphabet",
            ticker: "GOOGL",
            marketCap: 1876556400000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Amazon",
            ticker: "AMZN",
            marketCap: 2005630000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "NVIDIA",
            ticker: "NVDA",
            marketCap: 2708640000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Berkshire Hathaway",
            ticker: "BRK.B",
            marketCap: 1145090000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Tesla",
            ticker: "TSLA",
            marketCap: 917810000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Meta Platforms",
            ticker: "META",
            marketCap: 1448168302087,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "UnitedHealth Group",
            ticker: "UNH",
            marketCap: 418640000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png"
            )!
        ),
        Stock(
            name: "Johnson & Johnson",
            ticker: "JNJ",
            marketCap: 154580000000,
            iconUrl: URL(
                string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png"
            )!
        ),
    ]
    
    @State var articles: [Article] = [
        Article(
            title: "Global Markets Rally on Economic Optimism",
            body: "Markets around the world surged today following optimistic economic forecasts from several leading institutions.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/global-markets")!
            ],
            ts: Date(),
            importanceLevel: 3
        ),
        Article(
            title: "New Advances in Renewable Energy Storage",
            body: "Researchers announced a breakthrough in battery technology that could make renewable energy sources far more viable.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/renewable-energy")!
            ],
            ts: Date(),
            importanceLevel: 4
        ),
        Article(
            title: "Federal Reserve Holds Interest Rates Steady",
            body: "The Federal Reserve announced it will maintain current interest rates amid ongoing inflation concerns.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/federal-reserve")!
            ],
            ts: Date(),
            importanceLevel: 5
        ),
        Article(
            title: "Major Tech Company Announces AI Assistant",
            body: "A leading tech company unveiled a new AI-powered assistant aimed at transforming the customer service industry.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/tech-news")!
            ],
            ts: Date(),
            importanceLevel: 4
        ),
        Article(
            title: "Breakthrough in Alzheimer's Research",
            body: "Scientists published promising results from a new drug trial aimed at slowing Alzheimer's progression.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/health")!
            ],
            ts: Date(),
            importanceLevel: 5
        ),
        Article(
            title: "Global Leaders Meet for Climate Summit",
            body: "World leaders gathered today to discuss new international efforts to address climate change.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/climate-summit")!
            ],
            ts: Date(),
            importanceLevel: 5
        ),
        Article(
            title: "Cryptocurrency Prices Tumble After Regulation Talks",
            body: "Bitcoin and other cryptocurrencies fell sharply after lawmakers proposed new regulatory measures.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/crypto")!
            ],
            ts: Date(),
            importanceLevel: 3
        ),
        Article(
            title: "Consumer Spending Beats Expectations",
            body: "Despite economic uncertainties, consumer spending rose more than expected last month.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/consumer-spending")!
            ],
            ts: Date(),
            importanceLevel: 2
        ),
        Article(
            title: "Electric Vehicle Adoption Surges in Europe",
            body: "New data shows electric vehicle sales are booming across Europe, driven by government incentives and infrastructure improvements.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/electric-vehicles")!
            ],
            ts: Date(),
            importanceLevel: 4
        ),
        Article(
            title: "US Housing Market Shows Signs of Stabilization",
            body: "After months of volatility, the US housing market appears to be stabilizing, with mortgage rates declining slightly.",
            imageUrl: URL(string: "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/8256x5504+0+0/resize/1600/quality/85/format/webp/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2F38%2Fc0%2Fbb59d6d042dd990325eaace6b282%2Fgettyimages-2210188669.jpg")!,
            sources: [
                URL(string: "https://npr.org/housing-market")!
            ],
            ts: Date(),
            importanceLevel: 3
        )
    ]

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("bgNavy")
                    .ignoresSafeArea()
                
                //            if let portfolio {
                ScrollView {
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
                                            if selectedStock == stock {
                                                selectedStock = nil
                                            }
                                            else {
                                                selectedStock = stock
                                            }
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
                        
                        BentoGrid(articles: $articles)
                        
                        Spacer()
                    }
                    //            }
                    //            else {
                    //                ProgressView()
                    //            }
                }
                //        .task { await loadData() }
            }
        }
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


