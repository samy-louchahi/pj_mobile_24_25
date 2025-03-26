//
//  PDFGenerator.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import Foundation
import SwiftUI
import PDFKit
import UIKit

struct PDFUtils {
    static func generatePdf(for deposit: Deposit) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Gestion Dépôts",
            kCGPDFContextAuthor: "Ton App",
            kCGPDFContextTitle: "Fiche Dépôt"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 595.2
        let pageHeight = 841.8
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = 40
            
            func draw(_ text: String, font: UIFont = .systemFont(ofSize: 16), x: CGFloat = 20) {
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                text.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
                y += 24
            }
            
            draw("Fiche de Dépôt", font: .boldSystemFont(ofSize: 22))
            draw("Vendeur : \(deposit.seller?.name ?? "Nom inconnu")")
            draw("Étiquette : \(deposit.tag ?? "Inconnue")", font: .boldSystemFont(ofSize: 18))
            y += 8
            draw("Jeux déposés :", font: .boldSystemFont(ofSize: 20))
            
            for dg in deposit.depositGames ?? [] {
                let nomJeu = dg.game?.name ?? "Jeu inconnu"
                let qty = dg.exemplaires?.count ?? 0
                draw("- \(nomJeu) (\(qty) exemplaires)")
            }
        }
        
        return data
    }
    static func generateInvoicePdf(for sale: Sale, seller: Seller?, buyer: Buyer? = nil, localDetails: [LocalSaleDetail]? = nil) -> Data? {
            let pdfMetaData = [
                kCGPDFContextCreator: "Gestion Ventes",
                kCGPDFContextAuthor: "Ton App",
                kCGPDFContextTitle: "Facture Vente"
            ]
            
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = pdfMetaData as [String: Any]
            
            let pageWidth = 595.2
            let pageHeight = 841.8
            let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
            
            let data = renderer.pdfData { context in
                context.beginPage()
                var y: CGFloat = 40
                
                func draw(_ text: String, font: UIFont = .systemFont(ofSize: 16), x: CGFloat = 20) {
                    let attributes: [NSAttributedString.Key: Any] = [.font: font]
                    text.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
                    y += 24
                }

                draw("Facture de Vente", font: .boldSystemFont(ofSize: 22))
                draw("Vente ID : \(sale.saleId)")
                draw("Date : \(formattedDate(sale.saleDate))")
                draw("Vendeur : \(seller?.name ?? "Nom inconnu")")
                if let buyer = buyer {
                    draw("Acheteur : \(buyer.name)")
                    if let address = buyer.address {
                        draw("Adresse : \(address)")
                    }
                }
                draw("Statut : \(sale.saleStatus.rawValue.capitalized)")
                y += 12
                draw("Jeux vendus :", font: .boldSystemFont(ofSize: 18))

                var total: Double = 0

                if let localDetails {
                    for detail in localDetails {
                        let gameName = detail.depositGame.game?.name ?? "Jeu inconnu"
                        draw("- \(gameName)")

                        for key in detail.selectedExemplaireKeys {
                            if let ex = detail.depositGame.exemplaires?[key] {
                                let prix = String(format: "%.2f", ex.price ?? 0)
                                draw("    • \(key) - \(ex.state ?? "État inconnu") - \(prix) €", font: .systemFont(ofSize: 14))
                                total += ex.price ?? 0
                            }
                        }
                    }
                } else {
                    for detail in sale.saleDetails ?? [] {
                        let name = detail.depositGame?.game?.name ?? "Jeu inconnu"
                        let quantity = detail.quantity
                        let exemplaires = detail.depositGame?.exemplaires ?? [:]
                        let sold = exemplaires.values.prefix(quantity)
                        let subtotal = sold.reduce(0.0) { $0 + ($1.price ?? 0.0) }
                        total += subtotal
                        draw("- \(name) x\(quantity) = \(String(format: "%.2f", subtotal)) €")
                    }
                }

                y += 16
                draw("Total : \(String(format: "%.2f", total)) €", font: .boldSystemFont(ofSize: 18))
            }

            return data
        }
    
    static func sharePdf(_ data: Data, _ title : String) {
        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("\(title).pdf")
        try? data.write(to: tempUrl)
        
        let activityVC = UIActivityViewController(activityItems: [tempUrl], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
    private static func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
}
