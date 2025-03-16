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
    let price: Double?
    let state: String?
}

/// Représente un lien entre un dépôt et un jeu (table: deposit_games).
struct DepositGame: Codable, Identifiable {
    let depositGameId: Int
    var id: Int { depositGameId }

    let fees: Double
    let depositId: Int
    let gameId: Int

    /// Ce champ est un JSON dans ta DB.  
    /// Selon ta structure, ça peut être un tableau, un dictionnaire, etc.
    let exemplaires: [String: Exemplaire]?
    // ou let exemplaires: [Exemplaire]?  // selon la forme réelle des données
    
    enum CodingKeys: String, CodingKey {
        case depositGameId = "deposit_game_id"
        case fees
        case depositId     = "deposit_id"
        case gameId        = "game_id"
        case exemplaires
    }
}