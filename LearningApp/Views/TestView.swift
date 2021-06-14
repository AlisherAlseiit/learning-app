//
//  TestView.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 14.06.2021.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack {
                
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule!.test.questions.count ?? 0)")
                
                CodeTextView()
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
