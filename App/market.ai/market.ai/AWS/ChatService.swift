//
//  ChatService.swift
//  market.ai
//
//  Created by Marius Genton on 4/27/25.
//

import Foundation

class ChatService {
    static func getMessages(for articleId: Int) async throws -> [ChatMessage] {
        let data = try await RequestHelper.get("/articleMessages", params: ["article_id": articleId])
        return try JSONDecoder().decode([ChatMessage].self, from: data)
    }
    
    static func postMessage(articleId: Int, body: String) async throws {
        try await RequestHelper.post("/articleMessage", body: [
            "article_id": articleId,
            "body": body
        ])
    }
}
