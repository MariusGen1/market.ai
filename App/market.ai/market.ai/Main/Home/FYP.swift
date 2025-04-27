import SwiftUI

struct Home: View {
    @State private var greeting = ""
    @State private var selectedStock: Stock? = nil
    
    @State private var portfolio: [Stock]? = nil
    @State private var feed: [Article]? = nil
    
    private func loadData() async {
        do {
            portfolio = try await UserService.getPortfolio()
            feed = try await NewsService.getArticles()
        } catch { print(error) }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Color("bgNavy")
                        .ignoresSafeArea()
                    
                    if let feed {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                HStack {
                                    Text(greeting)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
//                                    Rectangle()
//                                        .fill(Color.gray.opacity(0.20))
//                                        .frame(height: 125)
//                                        .cornerRadius(15)
                                
                                // individual stocks
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        if let portfolio {
                                            ForEach(portfolio, id: \.name) { stock in
                                                StockPillFYP(
                                                    icon: stock.iconUrl!,
                                                    ticker: stock.ticker,
                                                    isSelected: selectedStock?.name == stock.name,
                                                    onTap: {
                                                        if selectedStock == stock {
                                                            selectedStock = nil
                                                        } else {
                                                            selectedStock = stock
                                                        }
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                                
                                // specific stock news section
                                if let selected = selectedStock {
                                    VStack {
                                        HStack {
                                            Text(selected.name)
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                            Spacer()
                                            Button(action: { selectedStock = nil }) {
                                                Image(systemName: "xmark")
                                                    .foregroundStyle(Color("purpleLight"))
                                                    .bold()
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                
                                else {
                                    NavigationLink(destination: ArticleView(article: feed[0])) {
                                        TopBento(geo: geo, article: feed[0])
                                    }
                                    
                                    HStack(spacing: 16) {
                                        NavigationLink(destination: ArticleView(article: feed[1])) {
                                            MiddleBento(geo: geo, article: feed[1])
                                        }
                                        NavigationLink(destination: ArticleView(article: feed[2])) {
                                            MiddleBento(geo: geo, article: feed[2])
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    VStack(spacing: 16) {
                                        ForEach(Array(feed.dropFirst(3)), id: \.self) { article in
                                            NavigationLink(destination: ArticleView(article: article)) {
                                                BottomBento(geo: geo, article: article)
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    else {
                        ProgressView()
                    }
                }
                .onAppear() {
                    setGreeting()
                }
                .task {
                    await loadData()
                }
            }
        }
    }
    private func setGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 3..<12:
            greeting = "Good Morning Max"
        case 12..<18:
            greeting = "Good Afternoon Max"
        default:
            greeting = "Good Evening Max"
        }
    }
}



