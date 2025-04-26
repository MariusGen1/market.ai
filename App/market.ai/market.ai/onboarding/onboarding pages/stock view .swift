import SwiftUI

struct StockView: View {
    
    @State var domain: String
    @State var ticker: String
    
    var logoURL: URL? { URL(string: "https://logo.clearbit.com/\(domain)") }
    
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
        .background(Color.gray.opacity(0.20))
        .cornerRadius(30)
    }
}
