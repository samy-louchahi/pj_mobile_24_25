//
//  VendorPieChartView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI
import Charts

struct VendorPieChartView: View {
    let vendorShares: [VendorShare]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Répartition des ventes par vendeur")
                .font(.title2)
                .bold()

            if vendorShares.isEmpty {
                Text("Aucune donnée disponible.")
                    .foregroundColor(.gray)
            } else {
                Chart {
                    ForEach(vendorShares, id: \.seller_id) { share in
                        SectorMark(
                            angle: .value("Montant", share.total),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Vendeur", share.sellerName))
                    }
                }
                .frame(height: 300)
                .chartLegend(.visible)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}