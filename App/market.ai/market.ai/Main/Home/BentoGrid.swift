//
//  BentoGrids.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI

struct BentoGrid: View {
    
    @Binding var articles: [Article]
    
    var body: some View {
        VStack(spacing: -17) {
            ForEach(Array(stride(from: 0, to: articles.count, by: 5)), id: \.self) { startIndex in
                if startIndex / 5 % 2 == 0 {
                    BentoTop(articles: Array(articles[startIndex..<min(startIndex+5, articles.count)]))
                } else {
                    BentoBottom(articles: Array(articles[startIndex..<min(startIndex+5, articles.count)]))
                }
            }
        }
    }
}

struct BentoTop: View {
    let articles: [Article]
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 15) {
                ForEach(0..<2) { index in
                    if index < articles.count {
                        NavigationLink(destination: ArticleView(article: articles[index])) {
                            ArticleCard(article: articles[index])
                                .frame(height: 170)
                        }
                    }
                }
            }
            VStack(spacing: 15) {
                ForEach(2..<5) { index in
                    if index < articles.count {
                        NavigationLink(destination: ArticleView(article: articles[index])) {
                            ArticleCard(article: articles[index])
                                .frame(height: 120)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct BentoBottom: View {
    let articles: [Article]
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 15) {
                ForEach(0..<3) { index in
                    if index < articles.count {
                        NavigationLink(destination: ArticleView(article: articles[index])) {
                            ArticleCard(article: articles[index])
                                .frame(height: 120)
                        }
                    }
                }
            }
            VStack(spacing: 15) {
                ForEach(3..<5) { index in
                    if index < articles.count {
                        NavigationLink(destination: ArticleView(article: articles[index])) {
                            ArticleCard(article: articles[index])
                                .frame(height: 170)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ArticleCard: View {
    let article: Article

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: article.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure(_):
                        Color.gray
                    @unknown default:
                        Color.gray
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Text(article.title)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(2)
                            .shadow(radius: 3)
                        Spacer()
                    }
                    .padding(8)
                    .background(Color("bgNavy"))
                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                }
            }
            .cornerRadius(12)
        }
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

