//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Christopher Ching on 2021-03-03.
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
