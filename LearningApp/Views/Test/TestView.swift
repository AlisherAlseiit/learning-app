//
//  TestView.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 14.06.2021.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var submitted = false
    
    @State var numCorrect = 0
    @State var showResults = false
    
    var body: some View {
        
        if model.currentQuestion != nil && showResults == false{
            
            VStack(alignment: .leading) {
                
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) {index in
                            
                            
                            
                            Button(action: {
                                
                                selectedAnswerIndex = index
                            }, label: {
                                
                                ZStack {
                                    
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        
                                        // User has selected the right answer
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        // User has selected the wrong answer
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }
                                        else if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                                
                            })
                            // MARK: - disabled button
                            .disabled(submitted)
                            
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                
                
                // Submit Button
                Button(action: {
                    
                    // Check if answer has been submitted
                    if submitted == true {
                        
                        
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            model.nextQuestion()
                            
                            showResults = true
                        }
                        else {
                           
                            model.nextQuestion()
                            
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                        
                        
                    }
                    else {
                        submitted = true
                        
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                   
                    
                  
                }, label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                })
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else if showResults == true{
            TestResultView(numCorrect: numCorrect)
        }
        else {
            ProgressView()
        }
    }
    
    var buttonText:String {
        
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                return "Finish" // or finish
            }
            else {
                return "Next"
            }
            
        }
        else {
            return "Submit"
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
