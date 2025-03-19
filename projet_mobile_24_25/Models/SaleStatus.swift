//
//  SaleStatus.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


enum SaleStatus: String, Codable, CaseIterable {
    case enCours    = "en cours"
    case finalise   = "finalisé"
    case annule     = "annulé"
}
