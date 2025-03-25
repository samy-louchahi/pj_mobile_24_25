//
//  SalesCountCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct SalesCountCardView: View {
    let count: Int

    var body: some View {
        VStack {
            Text("Nombre de ventes")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("\(count)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.indigo)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}