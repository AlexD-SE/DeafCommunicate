//
//  MainView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/14/23.
//

import SwiftUI
import TipKit

struct MainView: View {
    
    @StateObject public var model = MainViewModel()
    @Environment(\.colorScheme) var colorScheme
    @FocusState var textEditorFocused : Bool
    
    //Localized variables (for multi language support)
    let copyButton : LocalizedStringKey = "Copy Button"
    let saveToTextHistory : LocalizedStringKey = "Save To History Button"
    let deleteButton : LocalizedStringKey = "Delete Button"
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                GeometryReader{
                    
                    geometry in
                    
                    VStack{
                        
                        ScrollView{
                            
                            TextEditor(text: $model.text)
                                .focused($textEditorFocused)
                                .font(Font.custom(model.fontStyle, size:model.fontSize))
                                .autocorrectionDisabled(true)
                                .foregroundColor(model.isCustomFontColor == false ? colorScheme == .dark ? Color.white : Color.black : model.fontColor)
                                .frame(height: textEditorFocused == true ? geometry.size.height*0.75 : geometry.size.height*0.8)
                                .scrollContentBackground(.hidden)
                                .background(.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                }
                                .padding([.top, .leading, .trailing])
                                
                        }
                        .scrollDismissesKeyboard(.interactively)
                        .padding(.top)
                        .popoverTip(model.useKeyboardTip)
                        .onTapGesture{
                            model.useKeyboardTip.invalidate(reason: .actionPerformed)
                        }
                        
                        
                        if !Locale.current.identifier.contains("hy_"){
                            
                            if textEditorFocused == false{
                                
                                Button{
                                    
                                    if model.isTranscribing{
                                        
                                        Task.init(priority: .userInitiated){
                                            await model.stopTranscription()
                                        }
                                        
                                    }else{
                                        
                                        Task.init(priority: .userInitiated){
                                            await model.startTranscription()
                                        }
                                        
                                    }

                                }label:{
                                    if model.isTranscribing{
                                        Image(systemName: "microphone.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundStyle(.green)
                                    }else{
                                        Image(systemName: "microphone.slash.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundStyle(.red)
                                    }
                                }
                                .popoverTip(model.pressMicToBeginTip)
                                .onTapGesture {
                                    model.pressMicToBeginTip.invalidate(reason: .actionPerformed)
                                }
                                
                            }
                            
                        }
                        
                    }
                    .toolbar{
                        
                        ToolbarItem(placement: .topBarLeading){
                            
                            Menu{
                                
                                Button{
                                    model.copyTextToClipboard()
                                }label:{
                                    Label(copyButton, systemImage: "doc.on.doc")
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
                            NavigationLink(destination: SettingsView().environmentObject(model)){
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
                .onAppear(){
                    
                    UserDefaultsManager.shared.loadTextUserDefaults(fontSize: &model.fontSize, fontStyle: &model.fontStyle, isCustomFontColor: &model.isCustomFontColor, fontColor: &model.fontColor)
                        
                    TranscriptionEngine.shared.delegate = model
                    TranscriptionEngine.shared.prepare()
                    
                }
                
                if let notificationSymbol = model.notificationSymbol, let notificationText = model.notificationText, model.showNotification{
                    NotificationView(symbol: notificationSymbol, text: notificationText)
                }
                
            }
            .sheet(isPresented: $model.showTextHistory, onDismiss: {}, content: {
                
                TextHistoryView(showTextHistory: $model.showTextHistory).environmentObject(model)
                
            })
            .alert(model.alertTitle, isPresented: $model.showAlert,
                   actions: {Button("Ok", action: {model.showAlert = false})},
                   message: {Text(model.alertMessage)})
        }
    }
}
