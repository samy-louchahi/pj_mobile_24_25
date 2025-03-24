//
//  SalesOverTimeChartView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI
import Charts

struct SalesOverTimeChartView: View {
    let data: [SalesOverTimeData]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Évolution des ventes dans le temps")
                .font(.title2)
                .bold()

            if data.isEmpty {
                Text("Aucune vente pour cette session.")
                    .foregroundColor(.gray)
            } else {
                Chart(data, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Montant", item.total)
                    )
                    .foregroundStyle(.blue)
                    .symbol(Circle())
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 250)
                .chartYScale(domain: .automatic(includesZero: true))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}