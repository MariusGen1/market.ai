//
//  BentoGrids.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct TopBento: View {
    
    let geo: GeometryProxy
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: article.imageUrl) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width - 32, height: 375)
                        .clipped()
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            
            HStack(alignment: .bottom) {
                Text(article.title)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(2)
                Spacer()
                Text("3h ago")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .light))
            }
            .padding()
        }
        .background(.gray.opacity(0.20))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


struct MiddleBento: View {
    
    let geo: GeometryProxy
    let article: Article
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: article.imageUrl) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: (geo.size.width / 2) - 24, height: 200)
                        .clipped()
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(3)
                
                Text("3h ago")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .light))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.gray.opacity(0.20))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


struct BottomBento: View {
    
    let geo: GeometryProxy
    let article: Article
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.title)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("3h ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            AsyncImage(url: article.imageUrl) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
        }
        .padding(16)
        .frame(width: geo.size.width - 32, height: 125)
        .background(.gray.opacity(0.20))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}




struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
}

