import Foundation

class StockSearcher {
    private let apiKey = "Nr5wXB7hsyVNN_M4sLiakJdIIexXy61j"
    
    func searchStocks(for searchTerm: String, completion: @escaping (Result<[Ticker], Error>) -> Void) {
        
        searchTickers(searchTerm: searchTerm) { result in
            
            switch result {
            case .success(let tickers):
                let sortedTickers = self.sortTickers(tickers, by: searchTerm)
                self.fetchDetails(for: sortedTickers.map { $0.ticker }) { result in
                    switch result {
                    case .success(let details):
                        let mapped = details.compactMap { detail -> Ticker? in
                            guard
                                let iconUrlString = detail.branding?.iconUrl,
                                let iconUrl = URL(string: iconUrlString),
                                let marketCapDouble = detail.marketCap
                            else {
                                return nil
                            }
                            return Ticker(
                                name: detail.ticker,
                                iconUrl: iconUrl,
                                marketCap: Int(marketCapDouble)
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


let top50Tickers: [Ticker] = [
    Ticker(name: "AAPL", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YXBwbGUuY29t/images/2025-04-04_icon.png")!, marketCap: 3872409585350),
    Ticker(name: "MSFT", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWljcm9zb2Z0LmNvbQ/images/2025-04-04_icon.png")!, marketCap: 3133802247084),
    Ticker(name: "GOOGL", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWxwaGFiZXQuY29t/images/2025-04-04_icon.png")!, marketCap: 1876556400000),
    Ticker(name: "AMZN", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YW1hem9uLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 2005630000000),
    Ticker(name: "NVDA", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bnZpZGlhLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 2708640000000),
    Ticker(name: "BRK.B", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmVya3NoaXJlLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 1145090000000),
    Ticker(name: "TSLA", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGVzbGEuY29t/images/2025-04-04_icon.png")!, marketCap: 917810000000),
    Ticker(name: "META", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWV0YS5jb20/images/2025-04-04_icon.png")!, marketCap: 1448168302087),
    Ticker(name: "UNH", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dW5pdGVkaGVhbHRoZ3JvdXAuY29t/images/2025-04-04_icon.png")!, marketCap: 418640000000),
    Ticker(name: "JNJ", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/am5qLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 154580000000),
    Ticker(name: "V", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dmlzYS5jb20/images/2025-04-04_icon.png")!, marketCap: 335170000000),
    Ticker(name: "XOM", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/eG9tLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 108570000000),
    Ticker(name: "JPM", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/anBtLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 243550000000),
    Ticker(name: "PG", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGcuY29t/images/2025-04-04_icon.png")!, marketCap: 161020000000),
    Ticker(name: "MA", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWFzdGVyY2FyZC5jb20/images/2025-04-04_icon.png")!, marketCap: 533480000000),
    Ticker(name: "HD", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/aG9tZWRlcG90LmNvbQ/images/2025-04-04_icon.png")!, marketCap: 357580000000),
    Ticker(name: "CVX", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y2hlei5jb20/images/2025-04-04_icon.png")!, marketCap: 138730000000),
    Ticker(name: "LLY", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/ZWxpbGlsbHkuY29t/images/2025-04-04_icon.png")!, marketCap: 884540000000),
    Ticker(name: "MRK", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWVyY2suY29t/images/2025-04-04_icon.png")!, marketCap: 82740000000),
    Ticker(name: "PEP", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/cGVwc2ljby5jb20/images/2025-04-04_icon.png")!, marketCap: 133380000000),
    Ticker(name: "KO", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y29jYS1jb2xhLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 71910000000),
    Ticker(name: "ABBV", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWJidi5jb20/images/2025-04-04_icon.png")!, marketCap: 186060000000),
    Ticker(name: "AVGO", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YnJvYWRjb20uY29t/images/2025-04-04_icon.png")!, marketCap: 192310000000),
    Ticker(name: "COST", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y29zdGNvLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 977160000000),
    Ticker(name: "BAC", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YmFua2FtZXJpY2EuY29t/images/2025-04-04_icon.png")!, marketCap: 39690000000),
    Ticker(name: "WMT", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/d2FsbWFydC5jb20/images/2025-04-04_icon.png")!, marketCap: 95090000000),
    Ticker(name: "TMO", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGhlcm1vZmlzaGVyLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 424240000000),
    Ticker(name: "DIS", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/ZGlzLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 90280000000),
    Ticker(name: "ADBE", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/YWRvYmUuY29t/images/2025-04-04_icon.png")!, marketCap: 367720000000),
    Ticker(name: "CSCO", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/Y2lzY28uY29t/images/2025-04-04_icon.png")!, marketCap: 56710000000),
    Ticker(name: "NFLX", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bmV0ZmxpeC5jb20/images/2025-04-04_icon.png")!, marketCap: 1101530000000),
    Ticker(name: "INTC", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/aW50ZWwuY29t/images/2025-04-04_icon.png")!, marketCap: 20050000000),
    Ticker(name: "CRM", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/c2FsZXNmb3JjZS5jb20/images/2025-04-04_icon.png")!, marketCap: 267850000000),
    Ticker(name: "NKE", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bmlrZS5jb20/images/2025-04-04_icon.png")!, marketCap: 57620000000),
    Ticker(name: "ORCL", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/b3JhY2xlLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 138490000000),
    Ticker(name: "MCD", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/bWNkb25hbGRzLmNvbQ/images/2025-04-04_icon.png")!, marketCap: 316740000000),
    Ticker(name: "TXN", iconUrl: URL(string: "https://api.polygon.io/v1/reference/company-branding/dGV4YXMuaW5zdC5jb20/images/2025-04-04_icon.png")!, marketCap: 162860000000)
]
 

 

