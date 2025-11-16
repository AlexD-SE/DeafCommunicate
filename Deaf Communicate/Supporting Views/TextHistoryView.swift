//
//  HistoryView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct TextHistoryView: View{
    
    //General variables
    @Bindable var model: MainViewModel
    @State var showNoTextHistoryAlert = false
    @State var showDeleteTextHistoryAlert = false
    
    //Localized variables (for multi language support)
    let textHistoryViewTitle : LocalizedStringKey = "Text History View Title"
    let textHistoryViewInstructions : LocalizedStringKey = "Text History View Instructions"
    let noTextHistoryAlertTitle: LocalizedStringKey = "No Text History Alert Title"
    let noTextHistoryAlertMessage: LocalizedStringKey = "No Text History Alert Message"
    let deleteTextHistoryAlertTitle: LocalizedStringKey = "Delete Text History Alert Title"
    let deleteTextHistoryAlertMessage: LocalizedStringKey = "Delete Text History Alert Message"
    
    var body: some View{
        
        VStack{
            
            if !(model.textHistory.isEmpty){
                
                ZStack(alignment: .center){
                    
                    if #available(iOS 26.0, *) {
                        Button(action: {
                            showDeleteTextHistoryAlert = true
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding([.top, .bottom], 8)
                                .padding([.trailing, .leading], 2)
                        })
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .buttonStyle(.glassProminent)
                        .tint(.red.opacity(0.9))
                    } else {
                        Button(action: {
                            showDeleteTextHistoryAlert = true
                        }, label: {
                            Image(systemName: "trash.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        })
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tint(.red.opacity(0.9))
                    }
                    
                    Text(textHistoryViewTitle)
                        .font(.title3)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if #available(iOS 26.0, *) {
                        Button(action: {
                            model.showTextHistory = false
                        }, label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding([.top, .bottom], 10)
                                .padding([.trailing, .leading], 5)
                        })
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .buttonStyle(.glassProminent)
                    } else {
                        Button(action: {
                            model.showTextHistory = false
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        })
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                }
                
                Text(textHistoryViewInstructions)
                    .font(.system(size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                
                List(){
                    
                    ForEach($model.textHistory, id:\.self){
                        
                        pastText in
                        
                        Button(){
                            
                            model.text = pastText.wrappedValue
                            model.showTextHistory = false
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
                model.showTextHistory = false
            }, label: {
                Text("OK")
            })
        }, message: {
            Text(noTextHistoryAlertMessage)
        })
        .alert(deleteTextHistoryAlertTitle, isPresented: $showDeleteTextHistoryAlert, actions: {
            Button(role: .destructive, action: {
                model.textHistory.removeAll()
                showNoTextHistoryAlert = true
            }, label: {
                Text("Delete")
            })
        }, message: {
            Text(deleteTextHistoryAlertMessage)
        })
        .onAppear{
            if model.textHistory.count == 0{
                showNoTextHistoryAlert = true
            }else{
                showNoTextHistoryAlert = false
            }
        }
    }
    
    func deleteTextFromHistory(at offsets: IndexSet){
        model.textHistory.remove(atOffsets: offsets)
        
        if model.textHistory.count == 0{
            Task(priority: .userInitiated){
                await MainActor.run{
                    model.showTextHistory = false
                }
            }
        }
    }
    
}

#Preview {
    let model = MainViewModel.shared
    model.textHistory = ["HELLO WORLD"]
    return TextHistoryView(model: model)
}
