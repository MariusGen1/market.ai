//
//  TopStocks.swift
//  market.ai
//
//  Created by Max Eisenberg on 4/26/25.
//

import SwiftUI


let top50stocks: [Stock] = [
    Stock(name: "Apple", ticker: "AAPL", marketCap: 3872409585350, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("AAPL")),
    Stock(name: "Microsoft", ticker: "MSFT", marketCap: 3133802247084, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("MSFT")),
    Stock(name: "Alphabet", ticker: "GOOGL", marketCap: 1876556400000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("GOOGL")),
    Stock(name: "Amazon", ticker: "AMZN", marketCap: 2005630000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("AMZN")),
    Stock(name: "NVIDIA", ticker: "NVDA", marketCap: 2708640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("NVDA")),
    Stock(name: "Berkshire Hathaway", ticker: "BRK.B", marketCap: 1145090000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("BRK.B")),
    Stock(name: "Tesla", ticker: "TSLA", marketCap: 917810000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("TSLA")),
    Stock(name: "Meta Platforms", ticker: "META", marketCap: 1448168302087, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png")!,  hardcodedImage: Image("META")),
    Stock(name: "UnitedHealth Group", ticker: "UNH", marketCap: 418640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("UNH")),
    Stock(name: "Johnson & Johnson", ticker: "JNJ", marketCap: 154580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("JNJ")),
    Stock(name: "Visa", ticker: "V", marketCap: 335170000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dmlzYS5jb20/images/2025-04-04_icon.png")!,  hardcodedImage: Image("V")),
    Stock(name: "Exxon Mobil", ticker: "XOM", marketCap: 108570000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/eG9tLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("XOM")),
    Stock(name: "JPMorgan Chase", ticker: "JPM", marketCap: 243550000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/anBtLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("JPM")),
    Stock(name: "Procter & Gamble", ticker: "PG", marketCap: 161020000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGcuY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("PG")),
    Stock(name: "Mastercard", ticker: "MA", marketCap: 533480000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWFzdGVyY2FyZC5jb20/images/2025-04-04_icon.png")!,  hardcodedImage: Image("MA")),
    Stock(name: "Home Depot", ticker: "HD", marketCap: 357580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/aG9tZWRlcG90LmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("HD")),
    Stock(name: "Chevron", ticker: "CVX", marketCap: 138730000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y2hlei5jb20/images/2025-04-04_icon.png")!,  hardcodedImage: Image("CVX")),
    Stock(name: "Eli Lilly", ticker: "LLY", marketCap: 884540000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/ZWxpbGlsbHkuY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("LLY")),
    Stock(name: "Merck & Co.", ticker: "MRK", marketCap: 82740000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWVyY2suY29t/images/2025-04-04_icon.png")!,  hardcodedImage: Image("MRK")),
    Stock(name: "PepsiCo", ticker: "PEP", marketCap: 133380000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGVwc2ljby5jb20/images/2025-04-04_icon.png")!,  hardcodedImage: Image("PEP")),
    Stock(name: "Coca-Cola", ticker: "KO", marketCap: 71910000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y29jYS1jb2xhLmNvbQ/images/2025-04-04_icon.png")!,  hardcodedImage: Image("KO"))
]
