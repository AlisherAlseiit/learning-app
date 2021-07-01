//
//  LoginView.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 25.06.2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        
        if loginMode == Constants.LoginMode.login {
            return "Login"
        }
        else {
            return "Sign up"
        }
        
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            // Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            
            // Title
            Text("Learngzilla")
            
            Spacer()
            // Picker
            Picker(selection: $loginMode, label: Text("Hey")) {
                
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign up")
                    .tag(Constants.LoginMode.creteAccount)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Form
            Group {
                TextField("Email", text: $email)
                
                
                if loginMode == Constants.LoginMode.creteAccount {
                    TextField("Name", text: $name)
                }
                
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    Section {
                        Text(errorMessage!)
                    }
                }
                
            }
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                        guard error == nil else {
                            errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        
                        model.getUserData()
                        
                        model.checkLogin()
                        
                        
                    }
                }
                else {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        
                        let firebaseuser = Auth.auth().currentUser
                        let db = Firestore.firestore()
                        let ref = db.collection("users").document(firebaseuser!.uid)
                        
                        ref.setData(["name":name], merge: true)
                        
                        // Update the user meta data
                        let user = UserService.shared.user
                        user.name = name
                        
                        model.checkLogin()
                        
                        
                    }
                }
            } label: {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height:40)
                        .cornerRadius(10)
                    
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
