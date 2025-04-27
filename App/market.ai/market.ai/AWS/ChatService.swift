//
//  ChatService.swift
//  market.ai
//
//  Created by Marius Genton on 4/27/25.
//

import Foundation

class ChatService {
    static func postMessage(articleId: Int, message: String) async throws {
        try await RequestHelper.post("/articleMessage", body: [
            "article_id": articleId,
            "body": message
        ])
    }
    
    static func getMessages(articleId: Int) async throws -> [ChatMessage] {
        let data = try await RequestHelper.get("/articleMessages", params: [
            "article_id": articleId
        ])
        return try JSONDecoder().decode([ChatMessage].self, from: data)
    }
}
