//
//  StockTableView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct StockTableView: View {
    let stocksDict: [Int: Stock]
    let games : [Game]
    
    // Transformer le dictionnaire en tableau pour itérer
    private var stocks: [Stock] { Array(stocksDict.values) }
    
    private func gameName(for gameId: Int) -> String {
           games.first(where: { $0.gameId == gameId })?.name ?? "Inconnu"
       }
       
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Détails des Stocks")
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(stocks) { (stock : Stock) in
                HStack {
                    Text("Jeu : \(gameName(for: stock.gameId))")
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Initial: \(stock.initialQuantity)")
                        .frame(width: 80, alignment: .center)
                    Spacer()
                    Text("Actuel: \(stock.currentQuantity)")
                        .frame(width: 80, alignment: .trailing)
                }
                .padding(.vertical, 4)
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
