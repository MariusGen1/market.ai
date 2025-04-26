import SwiftUI

struct StockView: View {
    
    let icon: URL
    let ticker: String
    
    @Binding var selectedStocks: [Ticker]
    
    var isSelected: Bool { selectedStocks.contains(where: { $0.name == ticker })}
    
    var body: some View {
        HStack(spacing: 0) {
            if let url = URL(string: "\(icon)?apiKey=Nr5wXB7hsyVNN_M4sLiakJdIIexXy61j") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        EmptyView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 27, height: 27)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 10)
                    case .failure(_):
                        EmptyView()
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
                        name: ticker,
                        iconUrl: icon,
                        marketCap: 0
                    )
                )
            }
        }
    }
}
