import SwiftUI

struct Home: View {
    @State private var selectedStock: Stock? = nil
    
    @State private var portfolio: [Stock]? = nil
    @State private var feed: [Article]? = nil
    @Environment(\.navigationController) var navigationController
    
    private func loadData() async {
        do {
            portfolio = try await UserService.getPortfolio()
            feed = try await NewsService.getArticles()
        } catch { print(error) }
    }
    
    var greeting: String {
        guard case .home(let user) = navigationController.screen else { return "Welcome!" }
        guard let name = user.displayName, !name.isEmpty else { return "Welcome!" }
        let firstname = String(name.split(separator: " ")[0])
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 3..<12: return "Good Morning \(firstname)"
        case 12..<18: return "Good Afternoon \(firstname)"
        default: return "Good Evening \(firstname)"
        }
    }
    
    var filteredFeed: [Article]? {
        guard let feed else { return nil }
        guard let selectedStock else { return feed }
        return feed.filter({ $0.relevantTickers.contains(selectedStock.ticker) })
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Color("bgNavy")
                        .ignoresSafeArea()
                    
                    if let filteredFeed {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                HStack {
                                    Text(greeting)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding([.horizontal, .top])
                                    Spacer()
                                }
                                
                                // individual stocks
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        if let portfolio {
                                            ForEach(portfolio, id: \.ticker) { stock in
                                                StockPillFYP(
                                                    icon: stock.iconUrl,
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
                                    .padding(.horizontal)
                                }
                                .padding(.vertical, -8)
                                
//                                Text("Pleasure to have you, Marius! We're preparing your feed. Come back in a bit!")
//                                    .multilineTextAlignment(.center)
//                                    .padding(.horizontal, 40)
//                                    .foregroundColor(.white)
//                                    .opacity(0.8)
//                                    .padding(.top, 100)
//                                    .font(.footnote)
//                                
//                                 specific stock news section
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
                                
                                if !filteredFeed.isEmpty {
                                    NavigationLink(destination: ArticleView(article: filteredFeed[0])) {
                                        TopBento(geo: geo, article: filteredFeed[0])
                                    }
                                } else {
                                    Text("Sorry, nothing for now!")
                                        .fontWeight(.semibold)
                                        .opacity(0.7)
                                        .padding(.top, 50)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                                
                                HStack(spacing: 16) {
                                    if filteredFeed.count >= 2 {
                                        NavigationLink(destination: ArticleView(article: filteredFeed[1])) {
                                            MiddleBento(geo: geo, article: filteredFeed[1])
                                        }
                                    }
                                    
                                    if filteredFeed.count >= 3 {
                                        NavigationLink(destination: ArticleView(article: filteredFeed[2])) {
                                            MiddleBento(geo: geo, article: filteredFeed[2])
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                if filteredFeed.count >= 4 {
                                    VStack(spacing: 16) {
                                        ForEach(Array(filteredFeed.dropFirst(3)), id: \.self) { article in
                                            NavigationLink(destination: ArticleView(article: article)) {
                                                BottomBento(geo: geo, article: article)
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .refreshable { await loadData() }
                    }
                    else {
                        ProgressView()
                    }
                }
                .task { await loadData() }
            }
        }
    }
}
