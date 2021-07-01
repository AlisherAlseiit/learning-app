//
//  ContentModel.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 11.06.2021.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    
    // Authenticatioin
    @Published var loggedIn = false
    
    
    //
    let db = Firestore.firestore()
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        
    }
    
    // MARK: - Authentication methods
    
    func checkLogin() {
        
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        // Check if user meta data has been fetched
        if UserService.shared.user.name == "" {
            getUserData()
        }
        
    }
    
    // MARK: - Data methods
    
    func saveData(writeToDatabase:Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            
            
            // Save the progress data locally
            let user = UserService.shared.user
            
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase {
                
                
                
                // Save it to the database
                let db = Firestore.firestore()
                let ref = db.collection("users").document(loggedInUser.uid)
                ref.setData(["lastModule":user.lastModule ?? NSNull(),
                             "lastLesson": user.lastLesson  ?? NSNull(),
                             "lastQuestion": user.lastQuestion  ?? NSNull()], merge: true)
                
                
            }
        }
        
        
    }
    
    
    func getUserData() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            
            
            guard error == nil, snapshot != nil else {
                return
            }
            
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int
            user.lastLesson = data?["lastLesson"] as? Int 
            user.lastQuestion = data?["lastQuestion"] as? Int
        }
        
    }
    
    // command + shift + f
    func getDatabaseData() {
        
        
        getLocalStyles()
        
        // Specify path
        let collection = db.collection("modules")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Create an array for the modules
                var modules = [Module]()
                
                // Loop throught the documents returned
                for doc in snapshot!.documents {
                    
                    
                    
                    // Create a new module instance
                    var m = Module()
                    
                    // Parse out the values from the document into th emodule instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    
                    
                    // Parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    // Add it to our array
                    modules.append(m)
                    
                    
                    
                    
                    // Add it to our array
                    
                }
                
                // Assign our modules to the published property
                DispatchQueue.main.async {
                    self.modules = modules
                }
                
            }
            
        }
        
    }
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var lessons = [Lesson]()
                
                for doc in snapshot!.documents {
                    
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add the lesson to the array
                    lessons.append(l)
                    
                }
                
                for (index, m) in self.modules.enumerated() {
                    
                    // Find the nodule we want
                    if m.id == module.id {
                        
                        // Set the lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Call the completion closure
                        completion()
                    }
                }
                
            }
            
        }
        
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var questions = [Question]()
                
                for doc in snapshot!.documents {
                    
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    
                    
                    questions.append(q)
                }
                
                for (index, q) in self.modules.enumerated() {
                    
                    if q.id == module.id {
                        
                        self.modules[index].test.questions = questions
                        
                        completion()
                    }
                }
            }
            
        }
        
    }
    
    
    
    
    // MARK: - Remote Data methods
    func getRemoteData() {
        
        let urlString = "https://alishergit.github.io/learningapp-data/data2.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        
        let requtest = URLRequest(url: url!)
        
        // Get the session an kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requtest) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    
                    self.modules += modules
                    
                }
                
            }
            catch{
                
            }
            
            
        }
        
        // Kick off data task
        dataTask.resume()
        
    }
    
    
    // MARK: - Local Data methods
    
    func getLocalStyles() {
        
        /*
         // Get a url to the json file
         let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
         
         do {
         // Read the file into a data object
         let jsonData = try Data(contentsOf: jsonUrl!)
         
         // Try to decode the json into an array of modules
         let jsonDecoder = JSONDecoder()
         let modules = try jsonDecoder.decode([Module].self, from: jsonData)
         
         // Assign parsed modules to modules property
         self.modules = modules
         }
         catch {
         // TODO log error
         print("Couldn't parse local data")
         }
         
         */
        
        // parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do{
            
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            print("Couldn't parse local data")
        }
        
        
    }
    
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleId:String) {
        
        for index in 0..<modules.count {
            if modules[index].id == moduleId {
                currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // Reset the questionIndex since the user is starting lessons now
        currentQuestionIndex = 0
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            currentLessonIndex = 0
            currentLesson = nil
            
            
        }
        
        // Save the progress
        saveData()
    }
    
    // MARK: - nextQuestion
    func nextQuestion() {
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
        // Save data
        saveData()
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    // MARK: - beginTest
    func beginTest(_ moduleId:String) {
        
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
        // Reset the lesson index since they're starting a test now
        currentLessonIndex = 0
        
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    // MARK: - Code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        data.append(Data(htmlString.utf8))
        
        // Technique 1
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        
        return resultString
    }
    
}
