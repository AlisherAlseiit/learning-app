//
//  Models.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 11.06.2021.
//

import Foundation

struct Module: Decodable, Identifiable {
    
    var id: String =  ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}

struct Content: Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
    
}


struct Test: Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Lesson: Decodable, Identifiable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
    
}

struct Question: Decodable, Identifiable {
    
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}

class User {
    var name: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
}

