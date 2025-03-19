//
//  UpdateSaleModalView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct UpdateSaleModalView: View {
    @State var sale: Sale
    @ObservedObject var viewModel: SaleViewModel
    let onClose: () -> Void

    @State private var selectedBuyer: Int?
    @State private var selectedSession: Int?
    @State private var selectedStatus: SaleStatus
    @State private var saleDate: Date
    @State private var isLoading = false
    
    init(sale: Sale, viewModel: SaleViewModel, onClose: @escaping () -> Void) {
        self.sale = sale
        self.viewModel = viewModel
        self.onClose = onClose
        _selectedBuyer = State(initialValue: sale.buyerId)
        _selectedSession = State(initialValue: sale.sessionId)
        _selectedStatus = State(initialValue: sale.saleStatus)
        _saleDate = State(initialValue: sale.saleDate)
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading){
                    Picker("Session", selection: $selectedSession) {
                        ForEach(viewModel.sessions) { session in
                            Text(session.name).tag(session.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Picker("Acheteur", selection: $selectedBuyer) {
                        Text("Aucun").tag(nil as Int?)
                        ForEach(viewModel.buyers) { buyer in
                            Text(buyer.name).tag(buyer.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    DatePicker("Date de vente", selection: $saleDate, displayedComponents: .date)

                    Picker("Statut", selection: $selectedStatus) {
                        ForEach(SaleStatus.allCases, id: \.self) { (status: SaleStatus) in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("Mettre à jour") {
                        Task {
                            isLoading = true
                            let updatedSale = PartialSale(
                                buyer_id: nil,
                                session_id: nil,
                                sale_date: nil,
                                sale_status: selectedStatus.rawValue)
                            await viewModel.updateSale(id: sale.id, saleData: updatedSale)
                            isLoading = false
                            onClose()
                        }
                    }
                    .disabled(isLoading)
                }
            }
            .navigationTitle("Modifier la vente")
            .toolbar {
                Button("Fermer") { onClose() }
            }
        }
    }
}
