//
//  Objects.swift
//  Carrot WIP
//
//  Created by Marius Genton on 4/25/25.
//

import Foundation

struct Ticker: Decodable, Encodable {
    let tickerId: Int
    let symbol: String
    let name: String
    let iconUrl: String
    let marketCap: Int
    
    enum CodingKeys: String, CodingKey {
        case tickerId = "ticker_id"
        case symbol
        case name
        case iconUrl = "icon_url"
        case marketCap = "market_cap"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tickerId = try container.decode(Int.self, forKey: .tickerId)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        marketCap = try container.decode(Int.self, forKey: .marketCap)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tickerId, forKey: .tickerId)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(name, forKey: .name)
        try container.encode(iconUrl, forKey: .iconUrl)
        try container.encode(marketCap, forKey: .marketCap)
    }
}

enum FinancialLiteracyLevel: Int {
    case low = 1
    case medium = 2
    case high = 3
}
