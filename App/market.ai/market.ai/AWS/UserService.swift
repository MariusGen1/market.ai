//
//  UserService.swift
//  market.ai
//
//  Created by Marius Genton on 4/25/25.
//

import Foundation

class UserService {
    static func createUser(uid: String, financialLiteracyLevel: FinancialLiteracyLevel, stocks: [Stock]) async throws {
        try await RequestHelper.post("/createUser", body: [
            "uid": uid,
            "financial_literacy_level": financialLiteracyLevel.rawValue,
            "stocks": stocks
        ])
    }
    
    static func updateFCMToken(to token: String) async throws {
        try await RequestHelper.post("/fcmToken", body: [
            "token": token
        ])
    }
    
    static func updatePortfolio(to stocks: [Stock]) async throws {
        try await RequestHelper.post("/updatePortfolio", body: [
            "stocks": stocks
        ])
    }
    
    static func getPortfolio() async throws -> [Stock] {
        let data = try await RequestHelper.get("/portfolio", params: [:])
        return try JSONDecoder().decode([Stock].self, from: data)
    }
}
