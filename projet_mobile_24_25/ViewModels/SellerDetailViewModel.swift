//
//  SellerDetailViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import Foundation
import SwiftUI

@MainActor
class SellerDetailViewModel: ObservableObject {
    @Published var deposits: [Deposit] = []
    @Published var saleDetails: [SaleDetail] = []

    @Published var totalSales: Double = 0
    @Published var totalDepositFees: Double = 0
    @Published var totalCommission: Double = 0
    @Published var montantARetourner: Double = 0

    let seller: Seller

    private let depositService = DepositService.shared
    private let saleService = SaleService.shared
    private let sessionService = SessionService.shared

    init(seller: Seller) {
        self.seller = seller
    }

    func fetchAll() async {
        do {
            let allDeposits = try await depositService.getAllDeposits()
            self.deposits = allDeposits.filter { $0.sellerId == seller.sellerId }

            self.saleDetails = try await saleService.getAllSaleDetails(sellerId: seller.sellerId)

            self.totalDepositFees = deposits.reduce(0) { acc, deposit in
                let gameFees = deposit.depositGames?.reduce(0) { gameAcc, dg in
                    let exemplaires = dg.exemplaires!.values
                    let totalValue = exemplaires.reduce(0) { $0 + ($1.price ?? 0) }
                    return gameAcc + (totalValue * dg.fees / 100)
                } ?? 0
                return acc + gameFees
            }

            var commissionTotal: Double = 0
            var salesTotal: Double = 0

            for detail in saleDetails {
                guard let dg = detail.depositGame,
                      let sale = detail.sale else { continue }

                let session = try await sessionService.getSessions().first(where: { $0.sessionId == sale.sessionId })

                let keys = detail.selectedKeys ?? []
                let exemplaires = dg.exemplaires ?? [:]
                let montant = keys.reduce(0) { $0 + (exemplaires[$1]?.price ?? 0) }
                salesTotal += montant
                if let session {
                    commissionTotal += montant * (session.commission / 100)
                }
            }

            self.totalSales = salesTotal
            self.totalCommission = commissionTotal
            self.montantARetourner = salesTotal - commissionTotal

        } catch {
            print("❌ Erreur chargement SellerDetailViewModel: \(error.localizedDescription)")
        }
    }
}
