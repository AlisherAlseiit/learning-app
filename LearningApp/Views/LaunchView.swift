//
//  LaunchView.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 25.06.2021.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if !model.loggedIn {
            
            LoginView()
                .onAppear {
                    // Check if the user logged in or out
                    model.checkLogin()
                }
        }
        else {
            
            // show the logged in view
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Learn")
                        }
                    }
            }
            .onAppear {
                model.getDatabaseData()
            } // MARK: - On Receive
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                
                // Save progress to the database when th eapp is moving from active to background
                model.saveData(writeToDatabase: true)
            }
        }
    }
    
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
