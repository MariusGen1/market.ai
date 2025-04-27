//
//  Objects.swift
//  Carrot WIP
//
//  Created by Marius Genton on 4/25/25.
//

import SwiftUI

struct Stock: Identifiable, Codable, Equatable {
    
    var id: String { ticker }

    let name: String
    let ticker: String
    let marketCap: Int
    let iconUrl: URL?

    var hardcodedImage: Image?

    enum CodingKeys: String, CodingKey {
        case name, ticker
        case marketCap = "market_cap"
        case iconUrl   = "icon_url"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name      = try c.decode(String.self, forKey: .name)
        ticker    = try c.decode(String.self, forKey: .ticker)
        marketCap = try c.decode(Int.self,    forKey: .marketCap)
        iconUrl   = try c.decode(URL?.self,   forKey: .iconUrl)
        hardcodedImage = nil
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name,      forKey: .name)
        try c.encode(ticker,    forKey: .ticker)
        try c.encode(marketCap, forKey: .marketCap)
        try c.encodeIfPresent(iconUrl, forKey: .iconUrl)
    }

    init(
      name: String,
      ticker: String,
      marketCap: Int,
      iconUrl: URL?,
      hardcodedImage: Image? = nil   
    ) {
        self.name            = name
        self.ticker          = ticker
        self.marketCap       = marketCap
        self.iconUrl         = iconUrl
        self.hardcodedImage  = hardcodedImage
    }
}

extension Stock {
  var iconUrlWithAPIKey: URL? {
    guard let base = iconUrl,
          var comps = URLComponents(url: base,
                                   resolvingAgainstBaseURL: false)
    else { return nil }

    comps.queryItems = [
      URLQueryItem(name: "apiKey",
                   value: "Nr5wXB7hsyVNN_M4sLiakJdIIexXy61j")
    ]
    return comps.url
  }
}



enum FinancialLiteracyLevel: Int, CaseIterable {
    case beginner = 1
    case casual = 2
    case active = 3
    case expert = 4
    
    var name: String {
        switch self {
        case .beginner: return "Beginner"
        case .casual: return "Casual Investor"
        case .active: return "Active Trader"
        case .expert: return "Expert"
        }
    }
}

struct Article: Decodable, Hashable {
    let title: String
    let body: String
    let imageUrl: URL
    let sources: [URL]
    let ts: Date
    let importanceLevel: Int
    let portfolioImpact: String
    let summary: String
    let articleId: Int
    let relevantTickers: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case imageUrl = "image_url"
        case sources
        case ts
        case importanceLevel = "importance_level"
        case portfolioImpact = "portfolio_impact"
        case summary
        case articleId = "article_id"
        case relevantTickers = "relevant_tickers"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        
        let rawSources = try container.decode(String.self, forKey: .sources)
        sources = rawSources.split(separator: ",").compactMap { URL(string: String($0)) }
        
        let rawTs = try container.decode(String.self, forKey: .ts)
        ts = try rawTs.parseDBTimestamp()
        
        importanceLevel = try container.decode(Int.self, forKey: .importanceLevel)
        
        summary = try container.decode(String.self, forKey: .summary)
        portfolioImpact = try container.decode(String.self, forKey: .portfolioImpact)
        
        articleId = try container.decode(Int.self, forKey: .articleId)
       
        let rawRelevantTickers = try container.decode(String.self, forKey: .relevantTickers)
        relevantTickers = rawRelevantTickers.split(separator: ",").map({ String($0) })
    }
}

struct ChatMessage: Decodable, Identifiable {
    let messageId: Int
    let body: String
    let isUserMessage: Bool
    let ts: Date
    var id: Int { messageId }
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case body
        case isUserMessage = "is_user_message"
        case ts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try container.decode(Int.self, forKey: .messageId)
        body = try container.decode(String.self, forKey: .body)
        
        isUserMessage = (try container.decode(Int.self, forKey: .isUserMessage)) == 1
        
        let rawTs = try container.decode(String.self, forKey: .ts)
        ts = try rawTs.parseDBTimestamp()
    }
    
    init(body: String) {
        messageId = 3498423848
        self.body = body
        isUserMessage = true
        ts = Date()
    }
}
