//
//  DepotAndSaleManagerView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct DepotAndSaleManagerView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                Picker("Section", selection: $selectedTab) {
                    Text("Dépôts").tag(0)
                    Text("Ventes").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    DepositListView()
                } else {
                    SaleView()
                }
            }
            .navigationTitle("Dépôts & Ventes")
        }
    }
}