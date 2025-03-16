//
//  Session.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente une session (table: sessions).
struct Session: Codable, Identifiable {
    let sessionId: Int
    var id: Int { sessionId }

    let name: String
    let startDate: Date
    let endDate: Date
    let status: Bool
    let fees: Double
    let commission: Double

    enum CodingKeys: String, CodingKey {
        case sessionId  = "session_id"
        case name
        case startDate  = "start_date"
        case endDate    = "end_date"
        case status
        case fees
        case commission
    }
}