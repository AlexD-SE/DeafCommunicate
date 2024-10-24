//
//  FeedbackView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 7/9/22.
//

import SwiftUI

struct FeedbackView: View{
    
    //General variables
    private let privacyPolicy = URL(string:"https://www.freeprivacypolicy.com/live/9f2bb654-2ba1-48de-94a1-bff5e024a716")!
    private let supportDoc = URL(string:"https://docs.google.com/document/d/1e6b_tEsgU3HorVNb0ic0usIBWacegxeKhjYUq46RU1I/edit?usp=sharing")!
    
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
            
            Text("© 2025 Alexander Demerjian")
            
        }
        
    }
}
