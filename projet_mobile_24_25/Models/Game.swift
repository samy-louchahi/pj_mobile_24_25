//
//  Game.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un jeu (table: games).
struct Game: Codable, Identifiable, Hashable {
    let gameId: Int
    var id: Int { gameId }

    let name: String
    let publisher: String
    let description: String
    let picture: String

    enum CodingKeys: String, CodingKey {
        case gameId     = "game_id"
        case name       = "name"
        case publisher
        case description
        case picture
    }
}
