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

/// Le modèle complet pour la session
/// (que tu as déjà, p.ex. struct Session: Codable, Identifiable { ... })
struct SessionService {
    static let shared = SessionService()
    private let apiService = APIService()

    func getSessions() -> AnyPublisher<[Session], APIError> {
        apiService.get("/sessions")
    }

    func createSession(_ body: SessionCreate) -> AnyPublisher<Session, APIError> {
        apiService.post("/sessions", body: body)
    }

    func updateSession(_ id: Int, _ body: SessionUpdate) -> AnyPublisher<Session, APIError> {
        apiService.put("/sessions/\(id)", body: body)
    }

    func deleteSession(_ id: Int) -> AnyPublisher<Void, APIError> {
        apiService.delete("/sessions/\(id)")
    }
    func getGlobalBalance(_ id: Int) -> AnyPublisher<GlobalBalance, APIError> {
        apiService.get("finances/session/\(id)")
    }

}
