//
//  pour.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Petit struct pour un exemplaire JSON (si tu utilises un type plus précis qu’un simple dictionnaire).
/// Par exemple, l'attribut "exemplaires" est un JSON qui peut représenter un ensemble d'exemplaires.
struct Exemplaire: Codable {
    var price: Double?
    var state: String?
}

/// Représente un lien entre un dépôt et un jeu (table: deposit_games).
struct DepositGame: Codable, Identifiable {
    let depositGameId: Int
    var id: Int { depositGameId }

    let depositId: Int
    let gameId: Int
    let fees: Double

    var exemplaires: [String: Exemplaire]? // Un dictionnaire d'exemplaires
    var game: Game?   // Relation avec le jeu

    enum CodingKeys: String, CodingKey {
        case depositGameId = "deposit_game_id"
        case depositId = "deposit_id"
        case gameId = "game_id"
        case fees = "fees"
        case exemplaires = "exemplaires"
        case game = "Game"
    }
}
