import SwiftUI

struct StockPill: View {
  let stock: Stock
  @Binding var selectedStocks: [Stock]

  private var isSelected: Bool {
    selectedStocks.contains { $0.ticker == stock.ticker }
  }

  var body: some View {
    HStack(spacing: 8) {
      // hardcoded image preferred…
      if let img = stock.hardcodedImage {
        img
          .resizable()
          .frame(width:27, height:27)
          .clipShape(RoundedRectangle(cornerRadius:8))
          .padding(.trailing,10)

      // else fall back to your computed URL
      } else if let url = stock.iconUrlWithAPIKey {
        AsyncImage(url: url) { phase in
          switch phase {
          case .empty:
            Color.clear.frame(width:27, height:27)
          case .success(let img):
            img
              .resizable()
              .aspectRatio(contentMode:.fill)
              .frame(width:27, height:27)
          case .failure:
            Color.gray.opacity(0.2).frame(width:27,height:27)
          @unknown default:
            EmptyView()
          }
        }
        .clipShape(RoundedRectangle(cornerRadius:8))
        .padding(.trailing,10)
      }

      Text(stock.ticker.isEmpty ? stock.name : stock.ticker)
        .font(.system(size:12, weight:.bold))
        .foregroundColor(.white)
    }
    .padding(12)
    .background(isSelected
                ? Color.green.opacity(0.8)
                : Color.gray.opacity(0.2))
    .cornerRadius(30)
    .onTapGesture {
      if let idx = selectedStocks.firstIndex(where: { $0.ticker == stock.ticker }) {
        selectedStocks.remove(at: idx)
      } else {
        selectedStocks.append(stock)
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

