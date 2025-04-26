import SwiftUI

class StockSearcher {
    private let apiKey = "Nr5wXB7hsyVNN_M4sLiakJdIIexXy61j"
    
    func searchStocks(for searchTerm: String, completion: @escaping (Result<[Stock], Error>) -> Void) {
        
        searchTickers(searchTerm: searchTerm) { result in
            
            switch result {
            case .success(let tickers):
                let sortedTickers = self.sortTickers(tickers, by: searchTerm)
                self.fetchDetails(for: sortedTickers.map { $0.ticker }) { result in
                    switch result {
                    case .success(let details):
                        let mapped = details.compactMap { detail -> Stock? in
                            guard
                                let iconUrlString = detail.branding?.iconUrl,
                                let iconUrl = URL(string: iconUrlString),
                                let marketCapDouble = detail.marketCap
                            else {
                                return nil
                            }
                            return Stock(
                                name: detail.name,
                                ticker: "",
                                marketCap: Int(marketCapDouble),
                                iconUrl: iconUrl
                            )
                        }
                        completion(.success(mapped))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func searchTickers(searchTerm: String, completion: @escaping (Result<[TickerSummary], Error>) -> Void) {
        var components = URLComponents(string: "https://api.polygon.io/v3/reference/tickers")!
        components.queryItems = [
            URLQueryItem(name: "search", value: searchTerm),
            URLQueryItem(name: "active", value: "true"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "No data", code: -1))) }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TickerSearchResult.self, from: data)
                DispatchQueue.main.async { completion(.success(response.results ?? [])) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    private func fetchDetails(for tickers: [String], completion: @escaping (Result<[TickerDetail], Error>) -> Void) {
        let group = DispatchGroup()
        var details: [TickerDetail] = []
        var fetchErrors: [Error] = []
        let detailsQueue = DispatchQueue(label: "detailsQueue")

        for ticker in tickers {
            group.enter()
            
            var components = URLComponents(string: "https://api.polygon.io/v3/reference/tickers/\(ticker)")!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            guard let url = components.url else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() }
                
                if let error = error {
                    detailsQueue.async {
                        fetchErrors.append(error)
                    }
                    return
                }
                
                guard let data = data else {
                    detailsQueue.async {
                        fetchErrors.append(NSError(domain: "No data", code: -1))
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(TickerDetailResult.self, from: data)
                    detailsQueue.async {
                        details.append(response.results)
                    }
                } catch {
                    detailsQueue.async {
                        fetchErrors.append(error)
                    }
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            if !details.isEmpty {
                completion(.success(details))
            } else if let error = fetchErrors.first {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Unknown error", code: -1)))
            }
        }
    }
    
    private func sortTickers(_ tickers: [TickerSummary], by searchTerm: String) -> [TickerSummary] {
        return tickers.sorted { a, b in
            let aMatches = a.name.localizedCaseInsensitiveContains(searchTerm)
            let bMatches = b.name.localizedCaseInsensitiveContains(searchTerm)
            
            if aMatches != bMatches {
                return aMatches
            } else {
                return (a.marketCap ?? 0) > (b.marketCap ?? 0)
            }
        }
    }
}

struct TickerSearchResult: Decodable {
    let results: [TickerSummary]?
}

struct TickerSummary: Decodable {
    let ticker: String
    let name: String
    let marketCap: Double?
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case name
        case marketCap = "market_cap"
    }
}

struct TickerDetailResult: Decodable {
    let status: String
    let results: TickerDetail
}

struct TickerDetail: Decodable {
    let ticker: String
    let name: String
    let description: String?
    let homepageUrl: String?
    let marketCap: Double?
    let branding: Branding?

    enum CodingKeys: String, CodingKey {
        case ticker
        case name
        case description
        case homepageUrl = "homepage_url"
        case marketCap = "market_cap"
        case branding
    }

    struct Branding: Decodable {
        let logoUrl: String?
        let iconUrl: String?

        enum CodingKeys: String, CodingKey {
            case logoUrl = "logo_url"
            case iconUrl = "icon_url"
        }
    }
}


let top50stocks: [Stock] = [
    Stock(name: "Apple", ticker: "AAPL", marketCap: 3872409585350, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("AAPL")),
    Stock(name: "Microsoft", ticker: "MSFT", marketCap: 3133802247084, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("MSFT")),
    Stock(name: "Alphabet", ticker: "GOOGL", marketCap: 1876556400000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("GOOGL")),
    Stock(name: "Amazon", ticker: "AMZN", marketCap: 2005630000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("AMZN")),
    Stock(name: "NVIDIA", ticker: "NVDA", marketCap: 2708640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("NVDA")),
    Stock(name: "Berkshire Hathaway", ticker: "BRK.B", marketCap: 1145090000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("BRK.B")),
    Stock(name: "Tesla", ticker: "TSLA", marketCap: 917810000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("TSLA")),
    Stock(name: "Meta Platforms", ticker: "META", marketCap: 1448168302087, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png")!, hardcodedImage: Image("META")),
    Stock(name: "UnitedHealth Group", ticker: "UNH", marketCap: 418640000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("UNH")),
    Stock(name: "Johnson & Johnson", ticker: "JNJ", marketCap: 154580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("JNJ")),
    Stock(name: "Visa", ticker: "V", marketCap: 335170000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dmlzYS5jb20/images/2025-04-04_icon.png")!, hardcodedImage: Image("V")),
    Stock(name: "Exxon Mobil", ticker: "XOM", marketCap: 108570000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/eG9tLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("XOM")),
    Stock(name: "JPMorgan Chase", ticker: "JPM", marketCap: 243550000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/anBtLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("JPM")),
    Stock(name: "Procter & Gamble", ticker: "PG", marketCap: 161020000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGcuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("PG")),
    Stock(name: "Mastercard", ticker: "MA", marketCap: 533480000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWFzdGVyY2FyZC5jb20/images/2025-04-04_icon.png")!, hardcodedImage: Image("MA")),
    Stock(name: "Home Depot", ticker: "HD", marketCap: 357580000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/aG9tZWRlcG90LmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("HD")),
    Stock(name: "Chevron", ticker: "CVX", marketCap: 138730000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y2hlei5jb20/images/2025-04-04_icon.png")!, hardcodedImage: Image("CVX")),
    Stock(name: "Eli Lilly", ticker: "LLY", marketCap: 884540000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/ZWxpbGlsbHkuY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("LLY")),
    Stock(name: "Merck & Co.", ticker: "MRK", marketCap: 82740000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWVyY2suY29t/images/2025-04-04_icon.png")!, hardcodedImage: Image("MRK")),
    Stock(name: "PepsiCo", ticker: "PEP", marketCap: 133380000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGVwc2ljby5jb20/images/2025-04-04_icon.png")!, hardcodedImage: Image("PEP")),
    Stock(name: "Coca-Cola", ticker: "KO", marketCap: 71910000000, iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y29jYS1jb2xhLmNvbQ/images/2025-04-04_icon.png")!, hardcodedImage: Image("KO"))
]
