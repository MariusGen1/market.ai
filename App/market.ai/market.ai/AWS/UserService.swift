//
//  UserService.swift
//  market.ai
//
//  Created by Marius Genton on 4/25/25.
//

import Foundation

class UserService {
    static func createUser(uid: String, financialLiteracyLevel: FinancialLiteracyLevel, portfolio: [Ticker]) async throws {
        try await RequestHelper.post("/createUser", body: [
            "uid": uid,
            "financial_literacy_level": financialLiteracyLevel.rawValue,
            "tickers": portfolio
        ])
    }
    
    static func updateFCMToken(to token: String) async throws {
        try await RequestHelper.post("/fcmToken", body: [
            "token": token
        ])
    }
    
    static func updatePortfolio(to tickers: [Ticker]) async throws {
        try await RequestHelper.post("/updatePortfolio", body: [
            "tickers": tickers
        ])
    }
    
    static func getPortfolio() async throws -> [Ticker] {
        let data = try await RequestHelper.get("/portfolio", params: [:])
        return try JSONDecoder().decode([Ticker].self, from: data)
    }
}
