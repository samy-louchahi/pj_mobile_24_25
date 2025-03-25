//
//  Stock.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente le stock d’un jeu pour un vendeur lors d’une session (table: stocks).
struct Stock: Codable, Identifiable {
    let stockId: Int
    var id: Int { stockId }

    let sessionId: Int
    let sellerId: Int
    let gameId: Int
    let initialQuantity: Int
    let currentQuantity: Int

    var session: Session?
    var seller: Seller?
    var game: Game?

    enum CodingKeys: String, CodingKey {
        case stockId = "stock_id"
        case sessionId = "session_id"
        case sellerId = "seller_id"
        case gameId = "game_id"
        case initialQuantity = "initial_quantity"
        case currentQuantity = "current_quantity"
        case session = "Session"
        case seller = "Seller"
        case game = "Game"
    }
}
