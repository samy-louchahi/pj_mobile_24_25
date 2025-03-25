//
//  FinancialSummaryCardsView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

import SwiftUI

struct FinancialSummaryView: View {
    let balance: GlobalBalanceResponse

    var body: some View {
        VStack(spacing: 16) {
            SummaryCard(title: "Chiffre des ventes", value: balance.totalSales)
            SummaryCard(title: "Commissions encaissées", value: balance.totalCommission)
            SummaryCard(title: "Frais de dépôt encaissés", value: balance.totalDepositFees)
            SummaryCard(title: "Bénéfice net", value: balance.totalBenef)
        }
        .padding()
    }
}

struct SummaryCard: View {
    let title: String
    let value: Double

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text("\(value.formatted(.currency(code: "EUR")))")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
