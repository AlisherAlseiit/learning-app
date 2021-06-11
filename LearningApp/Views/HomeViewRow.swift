//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 11.06.2021.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image:String
    var title:String
    var description:String
    var count:String
    var time:String
    
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5 )
                // MARK: - aspectRatio
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            
            HStack {
                
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116 )
                    // MARK: - clipShape
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(title)
                        .bold()
                    
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)
                    
                    HStack {
                        
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text(count)
                            .font(Font.system( size: 10))
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        
                        Text(time)
                            .font(Font.system( size: 10))
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some description", count: "10 Lessons", time: "2 Hours")
    }
}
