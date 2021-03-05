//
//  SpaceTradersApp.swift
//  Shared
//
//  Created by Andreas Hausberger on 05.03.21.
//

import SwiftUI

@main
struct SpaceTradersApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
