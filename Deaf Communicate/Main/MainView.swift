//
//  MainView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/14/23.
//

import SwiftUI
import TipKit

struct MainView: View {
    
    @State var model: MainViewModel = MainViewModel.shared
    
    //Localized variables (for multi language support)
    let copyButton : LocalizedStringKey = "Copy Button"
    let shareButton : LocalizedStringKey = "Share Button"
    let saveToTextHistory : LocalizedStringKey = "Save To History Button"
    let deleteButton : LocalizedStringKey = "Delete Button"
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                GeometryReader { geometry in
                    
                    DictationView(model: model, geometryHeight: geometry.size.height)
                        .toolbar{
                            
                            //MARK: Toolbar
                            ToolbarItem(placement: .topBarLeading){
                                
                                Menu{
                                    
                                    Button{
                                        model.copyTextToClipboard()
                                    }label:{
                                        Label(copyButton, systemImage: "doc.on.doc")
                                    }
                                    
                                    ShareLink(item: model.text) {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    Button{
                                        model.saveTextToTextHistory()
                                    } label:{
                                        Label(saveToTextHistory, systemImage: "square.and.arrow.down")
                                    }
                                    
                                    Button(role: .destructive){
                                        model.deleteText()
                                    } label:{
                                        Label(deleteButton, systemImage: "trash")
                                    }
                                    
                                }label:{
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            
                            ToolbarItem(placement: .topBarLeading){
                                Button{
                                    Task.init(priority: .userInitiated){
                                        model.showTextHistory = true
                                    }
                                }label:{
                                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                        .resizable()
                                        .frame(width: 33, height: 30)
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing){
                                NavigationLink(destination: SettingsView(model: model)){
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing){
                                NavigationLink(destination: FeedbackView()){
                                    Image(systemName: "questionmark.bubble")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                            }
                            
                        }
                }
                .onAppear{
                    UserDefaultsManager.shared.loadTextUserDefaults(textSize: &model.textSize, textStyle: &model.textStyle, isCustomTextColor: &model.isCustomTextColor, textColor: &model.textColor)
                    
                    TranscriptionEngine.shared.delegate = model
                    TranscriptionEngine.shared.prepare()
                }
                
                if model.showNotification{
                    NotificationView(symbol: model.notificationSymbol, text: model.notificationText)
                        .transition(.move(edge: .top))
                        .zIndex(1) // Tells SwiftUI to keep this view above everything else during view layout animations/transitions
                }
            }
            .animation(.easeInOut, value: model.showNotification)
            .sheet(isPresented: $model.showTextHistory, onDismiss: {}, content: {
                TextHistoryView(model: model)
            })
            .alert(model.alertTitle, isPresented: $model.showAlert,
                   actions: {Button("Ok", action: {model.showAlert = false})},
                   message: {Text(model.alertMessage)})
        }
    }
}
