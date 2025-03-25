//
//  SalePageView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct SaleView: View {
    @ObservedObject var viewModel = SaleViewModel()
    @State private var showAddSaleWizard = false
    
    var body: some View {
        VStack {
             if viewModel.sales.isEmpty {
                VStack {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.blue)
                    Text("Aucune vente trouvée")
                        .font(.title2)
                        .bold()
                    Text("Ajoutez une nouvelle vente pour suivre les transactions.")
                        .foregroundColor(.gray)
                    Button("+ Enregistrer une vente") {
                        showAddSaleWizard = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                SaleListView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showAddSaleWizard, onDismiss: {
            Task {
                await viewModel.fetchInitialData()
                await viewModel.fetchSales()
            }
        }) {
            AddSaleWizardView(viewModel: viewModel)
        }
        .onAppear{
            Task{ await viewModel.fetchSales()}
        }
    }
}
