//
//  HistoryView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct TextHistoryView: View{
    
    //General variables
    @Binding var showTextHistory: Bool
    @EnvironmentObject private var mainViewModel: MainViewModel
    //@Environment(\.dismiss) private var dismiss
    @State var showNoTextHistoryAlert = false
    
    //Localized variables (for multi language support)
    let textHistoryViewTitle : LocalizedStringKey = "Text History View Title"
    let textHistoryViewInstructions : LocalizedStringKey = "Text History View Instructions"
    let noTextHistoryAlertTitle: LocalizedStringKey = "No Text History Alert Title"
    let noTextHistoryAlertMessage: LocalizedStringKey = "No Text History Alert Message"
    
    var body: some View{
        
        VStack{
            
            if !(mainViewModel.textHistory.isEmpty){
                
                Text(textHistoryViewTitle)
                    .font(.title3)
                    .bold()
                    .padding()
                
                Text(textHistoryViewInstructions)
                    .font(.system(size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                
                List(){
                    
                    ForEach($mainViewModel.textHistory, id:\.self){
                        
                        pastText in
                        
                        Button(){
                            
                            mainViewModel.text = pastText.wrappedValue
                            showTextHistory = false
                        }
                        label:{
                            
                            Text(pastText.wrappedValue)
                        }
                        
                    }
                    .onDelete(perform: deleteTextFromHistory)
                }
                .listStyle(DefaultListStyle())
            }
                
        }
        .alert(noTextHistoryAlertTitle, isPresented: $showNoTextHistoryAlert, actions: {
            
            Button(action: {
                
                showTextHistory = false
                
            }, label: {
                
                Text("OK")
            })
            
        }, message: {
            
            Text(noTextHistoryAlertMessage)
            
        })
        .onAppear{
            
            if mainViewModel.textHistory.count == 0{
                
                showNoTextHistoryAlert = true
                
            }else{
                showNoTextHistoryAlert = false
                
            }
            
        }
    }
    
    func deleteTextFromHistory(at offsets: IndexSet){
        mainViewModel.textHistory.remove(atOffsets: offsets)
        
        if mainViewModel.textHistory.count == 0{
            Task(priority: .userInitiated){
                await MainActor.run{
                    showTextHistory = false
                }
            }
        }
    }
    
}


