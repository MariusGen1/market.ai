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
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: geo.size.width - 32, height: 300)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(article.title.replacingOccurrences(of: "#", with: ""))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(article.ts.compactTimeSince(articleId: article.articleId) + " ago")
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
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: (geo.size.width / 2) - 24, height: 200)
            .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title.replacingOccurrences(of: "#", with: ""))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(article.ts.compactTimeSince(articleId: article.articleId)  + " ago")
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
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title.replacingOccurrences(of: "#", with: ""))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(article.ts.compactTimeSince(articleId: article.articleId) + " ago")
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
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                @unknown default:
                    Color.gray
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
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


extension Date {
    func compactTimeSince(articleId: Int) -> String {
        let diff = Date().timeIntervalSince(self)
        
        if diff < 10 {
            return "Just now"
        } else if diff < 60 {
            return "\(Int(diff))s"
        } else if diff < 3600 {
            let min = Int(diff / 60)
            return "\(min)m"
        } else if diff < 24 * 3600 {
            let hrs = Int(diff / 3600)
            return "\(hrs)h"
        } else {
            let days = Int(diff / (3600 * 24))
            
            if days <= 7 {
                return "\(days)d"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                return dateFormatter.string(from: self)
            }
        }
    }
}
