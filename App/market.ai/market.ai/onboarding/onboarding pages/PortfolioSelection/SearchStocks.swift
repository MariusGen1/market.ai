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
                                ticker: detail.ticker,
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
