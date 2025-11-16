//
//  FeedbackView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 7/9/22.
//

import SwiftUI

struct FeedbackView: View{
    
    //General variables
    private let privacyPolicy = URL(string:"https://www.freeprivacypolicy.com/live/aa29af7f-e72c-4bda-acf1-1b819daefe6f")!
    private let supportDoc = URL(string:"https://www.icloud.com/pages/0dfJvuvTchVtrtlThTJxiLYqw#Deaf_Communicate_Support_Document")!
    
    //Localized variables (for multi language support)
    let feedbackViewTitle : LocalizedStringKey = "Feedback View Title"
    let feedbackTextOne : LocalizedStringKey = "Feedback Text One"
    let feedbackTextTwo : LocalizedStringKey = "Feedback Text Two"
    let privacyPolicyTextOne : LocalizedStringKey = "Privacy Policy Text One"
    let privacyPolicyTextTwo : LocalizedStringKey = "Privacy Policy Text Two"
    let recognitionText : LocalizedStringKey = "Recognition Text"
    let supportTextOne : LocalizedStringKey = "Support Text One"
    let supportTextTwo : LocalizedStringKey = "Support Text Two"
    
    var body: some View{
        
        ScrollView{
            
            Text(supportTextOne)
                .font(.system(size:25, weight: .heavy))
                .padding()
            
            Link(supportTextTwo, destination: supportDoc)
                .padding()
            
            Rectangle()
                .fill(.gray)
                .frame(height:2)
                .padding()
            
            VStack{
                Text(feedbackTextOne)
                    .font(.system(size:25, weight: .heavy))
                
                Text(feedbackTextTwo)
                    .padding()
            }
            
            Rectangle()
                .fill(.gray)
                .frame(height:2)
                .padding()
            
            Text(privacyPolicyTextOne)
                .multilineTextAlignment(.center)
                .padding()
            
            Link(privacyPolicyTextTwo, destination: privacyPolicy)
                .padding()
            
            Text("© 2026 Alexander Demerjian")
            
        }
        
    }
}
