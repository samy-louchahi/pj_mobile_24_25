//
//  SessionService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import Foundation
import Combine

struct SessionCreate: Codable {
    let name: String
    let start_date: Date
    let end_date: Date
    let fees: Double
    let commission: Double
    // status ? Si besoin
}

struct SessionUpdate: Codable {
    let name: String
    let start_date: Date
    let end_date: Date
    let fees: Double
    let commission: Double
    let status: Bool
}


struct SessionService {
    static let shared = SessionService()
    private let apiService = APIService()

    // MARK: - GET all Sessions
    func getSessions() async throws -> [Session] {
        return try await apiService.get("/sessions")
    }

    // MARK: - CREATE Session
    func createSession(_ body: SessionCreate) async throws -> Session {
        return try await apiService.post("/sessions", body: body)
    }

    // MARK: - UPDATE Session
    func updateSession(_ id: Int, _ body: SessionUpdate) async throws -> Session {
        return try await apiService.put("/sessions/\(id)", body: body)
    }

    // MARK: - DELETE Session
    func deleteSession(_ id: Int) async throws {
        try await apiService.delete("/sessions/\(id)")
    }

    // MARK: - GET Global Balance for a Session
    func getGlobalBalance(_ id: Int) async throws -> GlobalBalance {
        return try await apiService.get("/finances/session/\(id)")
    }
}
