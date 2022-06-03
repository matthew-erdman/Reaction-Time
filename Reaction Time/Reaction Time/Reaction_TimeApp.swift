//
//  Reaction_TimeApp.swift
//  Reaction Time
//
//  Created by Matthew Erdman on 4/10/22.
//

import SwiftUI

@main
struct Reaction_TimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
