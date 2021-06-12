//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 12.06.2021.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            
            // TODO: Description
            
            // Next lesson button
            if model.hasNextLesson() {
                Button(action: {
                    
                    model.nextLesson()
                    
                }, label: {
                    
                    ZStack {
                        
                        Rectangle()
                            .frame(height:48)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                })
                
                
            }
            
            
            
        }
        .padding()
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
