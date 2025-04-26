import SwiftUI

struct FYP: View {
    @State private var greeting = ""
    @State private var selectedStock: Ticker? = nil
    
    @State private var portfolio: [Ticker] = [
        Ticker(name: "Tesla", iconUrl: URL(string: "https://logo.clearbit.com/tesla.com")!, marketCap: 34729323),
        Ticker(name: "Apple", iconUrl: URL(string: "https://logo.clearbit.com/apple.com")!, marketCap: 2789232389),
        Ticker(name: "Amazon", iconUrl: URL(string: "https://logo.clearbit.com/amazon.com")!, marketCap: 1382932389),
        Ticker(name: "Google", iconUrl: URL(string: "https://logo.clearbit.com/google.com")!, marketCap: 1892932389),
        Ticker(name: "Microsoft", iconUrl: URL(string: "https://logo.clearbit.com/microsoft.com")!, marketCap: 2492932389),
        Ticker(name: "Meta", iconUrl: URL(string: "https://logo.clearbit.com/meta.com")!, marketCap: 972932389)
    ]

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
                                icon: stock.iconUrl,
                                ticker: stock.name,
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
