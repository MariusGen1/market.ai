import Foundation


func fetchTickers(for searchTerm: String, apiKey: String, completion: @escaping (Result<[Ticker], Error>) -> Void) {
    var components = URLComponents(string: "https://api.polygon.io/v3/reference/tickers")!
    components.queryItems = [
        URLQueryItem(name: "search", value: searchTerm),
        URLQueryItem(name: "active", value: "true"),
        URLQueryItem(name: "apiKey", value: apiKey)
    ]
    
    URLSession.shared.dataTask(with: components.url!) { data, _, error in
        if let error = error {
            DispatchQueue.main.async { completion(.failure(error)) }
            return
        }
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else {
            DispatchQueue.main.async { completion(.success([])) }
            return
        }
        
        let group = DispatchGroup()
        var tickers: [Ticker] = []
        var fetchError: Error?
        
        for company in results.prefix(20) {
            guard let symbol = company["ticker"] as? String,
                  let name = company["name"] as? String else { continue }
            
            let domainGuess = name
                .components(separatedBy: ",").first?
                .replacingOccurrences(of: " ", with: "")
                .lowercased() ?? ""
            let iconUrl = URL(string: "https://logo.clearbit.com/\(domainGuess).com")!
            
            group.enter()
            let url = URL(string: "https://api.polygon.io/v1/meta/symbols/\(symbol)/company?apiKey=\(apiKey)")!
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    fetchError = error
                    group.leave()
                    return
                }
                
                var capInt = 0
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let cap = json["marketcap"] as? Double {
                    capInt = Int(cap)
                }
                
                tickers.append(
                    Ticker(
                        symbol: symbol,
                        name: name,
                        iconUrl: iconUrl,
                        marketCap: capInt
                    )
                )
                group.leave()
            }.resume()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(tickers))
            }
        }
    }.resume()
}
