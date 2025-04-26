import SwiftUI

struct StockView: View {
    let domain: String
    let ticker: String
    
    @Binding var selectedStocks: [Ticker]
    
    var logoURL: URL? { URL(string: "https://logo.clearbit.com/\(domain)") }
    
    var isSelected: Bool {
        selectedStocks.contains(where: { $0.name == ticker })
    }
    
    var body: some View {
        HStack(spacing: 10) {
            if let url = logoURL {
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
            }
            
            Text(ticker)
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
        }
        .padding(12)
        .background(isSelected ? Color.green.opacity(0.8) : Color.gray.opacity(0.2))
        .cornerRadius(30)
        .onTapGesture {
            if let index = selectedStocks.firstIndex(where: { $0.name == ticker }) {
                selectedStocks.remove(at: index)
            } else {
                selectedStocks.append(
                    Ticker(
                        symbol: ticker,
                        name: ticker,
                        iconUrl: URL(string: "https://logo.clearbit.com/\(domain)")!,
                        marketCap: 0
                    )
                )
            }
        }
    }
}
