//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 11.06.2021.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
