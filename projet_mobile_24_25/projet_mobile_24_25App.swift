//
//  projet_mobile_24_25App.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 11/03/2025.
//

import SwiftUI

@main
struct projet_mobile_24_25App: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
