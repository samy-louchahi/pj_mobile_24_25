//
//  SaleListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct SaleListView: View {
    @ObservedObject var viewModel: SaleViewModel
    @State private var selectedSession: Int? = nil
    @State private var selectedSeller: Int? = nil
    @State private var selectedStatus: SalesOpStatus? = nil
    @State private var showAddSale = false
    @State private var showUpdateSale = false
    @State private var selectedSale: Sale? = nil
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Liste des Ventes")
                    .font(.title)
                    .bold()
                    .padding()
                
                // Filtres
                HStack {
                    // Sélecteur de Session
                    Picker("Session", selection: $selectedSession) {
                        Text("Toutes").tag(nil as Int?)
                        ForEach(viewModel.sessions) { session in
                            Text(session.name).tag(session.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Sélecteur de Vendeur
                    Picker("Vendeur", selection: $selectedSeller) {
                        Text("Tous").tag(nil as Int?)
                        ForEach(viewModel.sellers) { seller in
                            Text(seller.name!).tag(seller.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Sélecteur de Statut
                    Picker("Statut", selection: $selectedStatus) {
                        Text("Tous").tag(nil as SalesOpStatus?)
                        ForEach(SalesOpStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status as SalesOpStatus?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                
                // Liste des ventes
                List(filteredSales, id: \.id) { sale in
                    let localDetails: [LocalSaleDetail]? = sale.saleDetails?.compactMap { detail in
                        guard let depositGame = detail.depositGame else { return nil }
                        let selectedKeys = detail.selectedKeys ?? []
                        return LocalSaleDetail(depositGame: depositGame, selectedExemplaireKeys: selectedKeys)
                    }

                    SaleCardView(
                        sale: sale,
                        localDetails: localDetails,
                        seller: sale.saleDetails?.isEmpty ?? true
                            ? nil
                            : viewModel.sellers.first(where: { $0.id == sale.saleDetails!.first!.sellerId }),
                        onDelete: { id in
                            Task { await viewModel.deleteSale(id: id) }
                        },
                        onUpdate: { _ in
                            selectedSale = sale
                            showUpdateSale = true
                        },
                        onFinalize: {
                            Task {
                                await viewModel.updateSale(
                                    id: sale.id,
                                    saleData: PartialSale(
                                        buyer_id: nil,
                                        session_id: nil,
                                        sale_date: nil,
                                        sale_status: SalesOpStatus.finalise.rawValue
                                    )
                                )
                            }
                        }
                    )
                }
                
                Button(action: { showAddSale = true }) {
                    Text("+ Nouvelle Vente")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $showAddSale) {
                AddSaleWizardView(viewModel: viewModel)
            }
            .sheet(isPresented: $showUpdateSale) {
                if let sale = selectedSale {
                    UpdateSaleModalView(sale: sale, viewModel: viewModel, onClose: { showUpdateSale = false })
                }
            }
            .onAppear{
                Task{ await viewModel.fetchSales()}
            }
        }
    }
    
    // Filtrage dynamique
    private var filteredSales: [Sale] {
        var filtered = viewModel.sales

        // Filtrer par session
        if let selectedSession = selectedSession {
            filtered = filtered.filter { $0.sessionId == selectedSession }
        }

        // Filtrer par vendeur
        if let selectedSeller = selectedSeller {
            filtered = filtered.filter { sale in
                let details = sale.saleDetails
                return ((details?.contains { $0.sellerId == selectedSeller }) != nil)
            }
        }

        // Filtrer par statut de vente
        if let selectedStatus = selectedStatus {
            filtered = filtered.filter { $0.saleStatus.rawValue == selectedStatus.rawValue }
        }

        return filtered
    }
}
