//
//  Gestionnaire.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un gestionnaire (table: gestionnaires).
struct Gestionnaire: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let password: String?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case password
        case createdAt
        case updatedAt
    }
}
