//
//  RequestHelper.swift
//  market.ai
//
//  Created by Marius Genton on 4/25/25.
//

import Foundation
import FirebaseAuth

enum ServiceErr: Error {
    case InvalidUrl
    case RequestError(method: String, endpoint: String, statusCode: Int, errorMessage: String)
    case InvalidResponse
}

struct ServerError : Decodable {
    private let error: MySQLError
    
    var description: String {
        return error.sqlMessage
    }
    
    enum CodingKeys: CodingKey {
        case error
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(MySQLError.self, forKey: .error)
    }
}

struct MySQLError: Decodable { let sqlMessage: String }

extension ServiceErr: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .InvalidUrl:
            return "Invalid URL"
        case .RequestError(let method, let endpoint, let statusCode, let errorMessage):
            #if DEBUG
            return "\(method) to \(endpoint) failed: \(errorMessage) (\(statusCode))"
            #else
            return errorMessage
            #endif
            
        case .InvalidResponse:
            return "Invalid Response"
        }
    }
}

public final class RequestHelper {
    private var user: User!
    
    static private let shared = RequestHelper()
    static private let base: String = "http://52.52.57.22:3000"
    
    static private let silentErrors = [
        "cancelled"
    ]
    
    static func configure(for user: User) {
        shared.user = user
    }
    
    static func get(_ endpoint: String, params: [String: Any], failSilently: Bool = false) async throws -> Data {
        guard
            let paramsString = params
                .map({ k, v in "\(k)=\(v)" })
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?
                .replacingOccurrences(of: "+", with: "%2B"),
            let url = URL(string: base + endpoint + "?" + paramsString)
        else { throw ServiceErr.InvalidUrl }
        
        var request = URLRequest(url: url)
        try await request.authenticate(for: shared.user)

        do {
            let startTime = Date()
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else { throw ServiceErr.InvalidResponse }
            
            let responseTime = Date().timeIntervalSince(startTime)
            print("GET to \(endpoint) responded with status code \(response.statusCode) in \(Int(responseTime * 1000))ms")
                        
            guard response.statusCode == 200 else {
                let error = try? JSONDecoder().decode(ServerError.self, from: data)
                let errorMessage = error?.description ?? String(bytes: data, encoding: .utf8) ?? "<<No error message provided>>"
                throw ServiceErr.RequestError(method: "GET", endpoint: endpoint, statusCode: response.statusCode, errorMessage: errorMessage)
            }
            
            return data
            
        } catch {
            if failSilently || silentErrors.contains(error.localizedDescription) {
                throw error
            } else {
                print(error)
                throw error
            }
        }
    }
    
    @discardableResult
    static func post(_ endpoint: String, body: [String: Any]) async throws -> Data {
        guard let url = URL(string: base + endpoint) else { throw ServiceErr.InvalidUrl }
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        try await request.authenticate(for: shared.user)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
                
        do {
            let startTime = Date()
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else { throw ServiceErr.InvalidResponse }
            
            let responseTimeMs = Int(Date().timeIntervalSince(startTime) * 1000)
            let debugString = "POST to \(endpoint) responded with status code \(response.statusCode) in \(responseTimeMs)ms"
            print(debugString)
            
            guard response.statusCode == 200 else {
                let error = try? JSONDecoder().decode(ServerError.self, from: data)
                let errorMessage = error?.description ?? String(bytes: data, encoding: .utf8) ?? "<<No error message provided>>"
                throw ServiceErr.RequestError(method: "POST", endpoint: endpoint, statusCode: response.statusCode, errorMessage: errorMessage)
            }
            
            return data
        } catch {
            if silentErrors.contains(error.localizedDescription) { throw error }
            print(error)
            throw error
        }
    }
}

fileprivate extension URLRequest {
    mutating func authenticate(for user: User) async throws {
        let idToken = try await user.getIDTokenResult()

        self.setValue(
            "Bearer \(idToken.token)",
            forHTTPHeaderField: "Authorization"
        )
    }
}

extension String {
    enum DateParsingError: Error { case InvalidFormat }

    func parseDBTimestamp() throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: self) { return date }
        else { throw DateParsingError.InvalidFormat }
    }
}
