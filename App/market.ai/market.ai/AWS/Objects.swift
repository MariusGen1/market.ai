//
//  Objects.swift
//  Carrot WIP
//
//  Created by Marius Genton on 4/25/25.
//

import Foundation

struct Stock: Decodable, Encodable {
    let name: String
    let ticker: String
    let marketCap: Int
    let iconUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case ticker
        case marketCap = "market_cap"
        case iconUrl = "icon_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        ticker = try container.decode(String.self, forKey: .ticker)
        marketCap = try container.decode(Int.self, forKey: .marketCap)
        iconUrl = try container.decode(URL?.self, forKey: .iconUrl)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(ticker, forKey: .ticker)
        try container.encode(marketCap, forKey: .marketCap)
        try container.encodeIfPresent(iconUrl, forKey: .iconUrl)
    }
    
    init(name: String, ticker: String, marketCap: Int, iconUrl: URL?) {
        self.name = name
        self.ticker = ticker
        self.marketCap = marketCap
        self.iconUrl = iconUrl
    }
}

enum FinancialLiteracyLevel: Int {
    case low = 1
    case medium = 2
    case high = 3
}

struct Article: Decodable {
    let title: String
    let body: String
    let imageUrl: URL
    let sources: [URL]
    let ts: Date
    let importanceLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case imageUrl = "image_url"
        case sources
        case ts
        case importanceLevel = "importance_level"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        
        let rawSources = try container.decode(String.self, forKey: .sources)
        sources = rawSources.split(separator: ",").map({ URL(string: String($0)) }).filter({ $0 != nil }).map({ $0! })
        
        let rawTs = try container.decode(String.self, forKey: .ts)
        ts = try rawTs.parseDBTimestamp()
        
        importanceLevel = try container.decode(Int.self, forKey: .importanceLevel)
    }
}
