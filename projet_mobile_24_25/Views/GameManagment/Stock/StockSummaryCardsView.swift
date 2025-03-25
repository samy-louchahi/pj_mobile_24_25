//
//  StockSummaryCardsView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct StockSummaryCardsView: View {
    let stocksDict: [Int: Stock]
    
    // Transformation en tableau
    private var stocks: [Stock] { Array(stocksDict.values) }
    
    // Calculs pour le résumé
    private var totalGames: Int {
        stocks.reduce(0) { $0 + $1.initialQuantity }
    }
    private var totalInStock: Int {
        stocks.reduce(0) { $0 + $1.currentQuantity }
    }
    private var totalSold: Int {
        stocks.reduce(0) { $0 + ($1.initialQuantity - $1.currentQuantity) }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            summaryCard(title: "Total des jeux déposés", value: totalGames)
            summaryCard(title: "Jeux en stock", value: totalInStock)
            summaryCard(title: "Jeux vendus", value: totalSold)
        }
    }
    
    private func summaryCard(title: String, value: Int) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
