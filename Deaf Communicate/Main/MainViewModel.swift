//
//  MainViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI
import Speech
import Intents

class MainViewModel: ObservableObject, TranscriptionEngineDelegate{
    
    //Localized variables (multi language support)
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    
    //Speech recognition variables
    @Published var isTranscribing = false
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    // Text variables
    @Published var text = ""
    @Published var textHistory: [String] = []
    @Published var noTextHistory = true
    @Published var showTextHistory: Bool = false
    
    // Font variables
    @Published var fontSize: Double = 50.0
    @Published var fontStyle: String = "SF Pro Regular"
    @Published var isCustomFontColor: Bool = false
    @Published var fontColor: Color = Color.black
    
    // Notification variables
    @Published var showNotification = false
    @Published var notificationText: LocalizedStringKey? = nil
    @Published var notificationSymbol: Image? = nil
    
    @Published var pressMicToBeginTip = UseMicrophoneButtonTip()
    @Published var useKeyboardTip = UseKeyboardTip()
    
    let firstTimeUsingApp = UserDefaultsManager.shared.firstTimeUsingApp()
    
    init(){
        UseMicrophoneButtonTip.firstTimeUsingApp = firstTimeUsingApp
        UseKeyboardTip.firstTimeUsingApp = firstTimeUsingApp
    }
    
    func startTranscription() async{
        await TranscriptionEngine.shared.startTranscription()
    }
    
    func stopTranscription() async{
        await TranscriptionEngine.shared.stopTranscription()
        UseKeyboardTip.didFinishDictate = true
    }
    
    /// Copies the text to the system wide general pasteboard.
    func copyTextToClipboard(){
        
        UIPasteboard.general.string = text
        
        DispatchQueue.main.async{
            self.notificationText = self.textCopiedNotification
            self.notificationSymbol = Image(systemName: "document.on.document")
            
            withAnimation{
                self.showNotification.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5){
            
            withAnimation{
                self.showNotification.toggle()
            }
            
            self.notificationText = nil
            self.notificationSymbol = nil
        }
    }
    
    /// Deletes the current text.
    func deleteText(){
        text=""
    }
    
    /// Saves the current text to the text history.
    func saveTextToTextHistory(){
        
        if (text != ""){
            
            textHistory.insert(text, at: 0)
            
            if noTextHistory {
                noTextHistory = false
            }
        }
        
        text=""
        
    }
    
    func didStartTranscription() {
        DispatchQueue.main.async{
            self.isTranscribing = true
        }
    }
    
    func transcribed(_ result: String) {
        DispatchQueue.main.async{
            self.text = result
        }
    }
    
    func didStopTranscription() {
        DispatchQueue.main.async{
            self.isTranscribing = false
        }
    }
    
    func transcriptionEngineError(_ error: TranscriptionEngineError){
        
        Task.init(priority: .high){
            await stopTranscription()
        }
        
        DispatchQueue.main.async{
            self.alertTitle = "Failed To Start Transcription"
            self.alertMessage = "\(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    
}
