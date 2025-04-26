import SwiftUI

struct StockPill: View {
    
    let icon: URL?
    let ticker: String
    
    @Binding var selectedStocks: [Stock]
    
    var isSelected: Bool { selectedStocks.contains(where: { $0.ticker == ticker })}
    
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
                    Stock(
                        name: "",
                        ticker: ticker,
                        marketCap: 0,
                        iconUrl: icon
                    )
                )
            }
        }
    }
}


struct StockPillFYP: View {
    let icon: URL
    let ticker: String
    var isSelected: Bool
    var onTap: (() -> Void)? = nil

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
                            .frame(width: 25, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 10)
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(ticker)
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .bold))
        }
        .padding(13)
        .background(isSelected ? Color.gray.opacity(0.6) : Color.gray.opacity(0.2))
        .cornerRadius(20)
        .onTapGesture {
            onTap?()
        }
    }
}

