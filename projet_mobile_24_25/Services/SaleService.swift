//
//  SaleCreate.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import Foundation
import Combine

// MARK: - Models

// Pour créer une vente
struct SaleCreate: Codable {
    let buyer_id: Int?
    let session_id: Int
    let sale_date: String? // Format ISO8601 ou "YYYY-MM-DD"
    let sale_status: String? // "en cours", "finalisé", "annulé"
}


// Pour créer une opération de vente
struct SaleOperationCreate: Codable {
    let sale_id: Int
    let commission: Double
    let sale_status: String? // "en cours", "finalisé", "annulé"
    let sale_date: String?
}


// Pour créer un détail de vente
struct SaleDetailCreate: Codable {
    let sale_id: Int
    let deposit_game_id: Int
    let quantity: Int?
}


// Types partiels pour mise à jour (si nécessaire)
struct PartialSale: Codable {
    let buyer_id: Int?
    let session_id: Int?
    let sale_date: String?
    let sale_status: String?
}

struct PartialSalesOperation: Codable {
    let sale_id: Int?
    let commission: Double?
    let sale_status: String?
    let sale_date: String?
}

struct PartialSaleDetail: Codable {
    let sale_id: Int?
    let deposit_game_id: Int?
    let quantity: Int?
}

// MARK: - SaleService

class SaleService {
    static let shared = SaleService()
    private let apiService = APIService()
    
    // MARK: - Sale Services
    
    /// Crée une nouvelle vente
    func createSale(_ saleData: SaleCreate) async throws -> Sale {
        return try await apiService.post("/sales", body: saleData)
    }
    
    /// Récupère toutes les ventes avec leurs détails
    func getAllSales() async throws -> [Sale] {
        return try await apiService.get("/sales")
    }
    
    /// Récupère une vente par ID
    func getSaleById(_ id: Int) async throws -> Sale {
        return try await apiService.get("/sales/\(id)")
    }
    
    /// Met à jour une vente (mise à jour partielle)
    func updateSale(_ id: Int, saleData: PartialSale) async throws -> Sale {
        return try await apiService.put("/sales/\(id)", body: saleData)
    }
    
    /// Supprime une vente
    func deleteSale(_ id: Int) async throws {
        try await apiService.delete("/sales/\(id)")
    }
    
    // MARK: - SalesOperation Services
    
    /// Crée une nouvelle opération de vente
    func createSalesOperation(_ opData: SaleOperationCreate) async throws -> SalesOperation {
        return try await apiService.post("/sale-operations", body: opData)
    }
    
    /// Récupère toutes les opérations de vente
    func getAllSalesOperations() async throws -> [SalesOperation] {
        return try await apiService.get("/saleOperations")
    }
    
    /// Récupère une opération de vente par ID
    func getSalesOperationById(_ id: Int) async throws -> SalesOperation {
        return try await apiService.get("/saleOperations/\(id)")
    }
    
    /// Met à jour une opération de vente
    func updateSalesOperation(_ id: Int, opData: PartialSalesOperation) async throws -> SalesOperation {
        return try await apiService.put("/saleOperations/\(id)", body: opData)
    }
    
    /// Supprime une opération de vente
    func deleteSalesOperation(_ id: Int) async throws {
        try await apiService.delete("/saleOperations/\(id)")
    }
    
    // MARK: - SaleDetail Services
    
    /// Crée un nouveau détail de vente
    func createSaleDetail(_ detailData: SaleDetailCreate) async throws -> SaleDetail {
        return try await apiService.post("/saleDetails", body: detailData)
    }
    
    /// Récupère tous les détails de vente (optionnellement filtrés par vendeur)
    func getAllSaleDetails(sellerId: Int? = nil) async throws -> [SaleDetail] {
        if let sellerId = sellerId {
            return try await apiService.get("/saleDetails?seller_id=\(sellerId)")
        } else {
            return try await apiService.get("/saleDetails")
        }
    }
    
    /// Récupère un détail de vente par ID
    func getSaleDetailById(_ id: Int) async throws -> SaleDetail {
        return try await apiService.get("/saleDetails/\(id)")
    }
    
    /// Met à jour un détail de vente
    func updateSaleDetail(_ id: Int, detailData: PartialSaleDetail) async throws -> SaleDetail {
        return try await apiService.put("/saleDetails/\(id)", body: detailData)
    }
    
    /// Supprime un détail de vente
    func deleteSaleDetail(_ id: Int) async throws {
        try await apiService.delete("/saleDetails/\(id)")
    }
}
