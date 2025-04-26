//
//  NewsService.swift
//  market.ai
//
//  Created by Marius Genton on 4/26/25.
//

import Foundation

class NewsService {
    static func getArticles() async throws -> [Article] {
        let data = try await RequestHelper.get("/articles", params: [:])
        return try JSONDecoder().decode([Article].self, from: data)
    }
}
