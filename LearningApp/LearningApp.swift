//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 11.06.2021.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
