//
//  VendorStatsCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct VendorStatsCardView: View {
    let stats: VendorStatsResponse

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistiques des vendeurs")
                .font(.title2)
                .bold()

            HStack {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.indigo)
                VStack(alignment: .leading) {
                    Text("Vendeurs participants")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(stats.totalVendors)")
                        .font(.title3)
                        .bold()
                }
                Spacer()
            }

            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                VStack(alignment: .leading) {
                    Text("Vendeur le plus actif")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(stats.topVendor.sellerName)
                        .font(.title3)
                        .bold()
                    Text("Jeux vendus : \(stats.topVendor.totalSales)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}