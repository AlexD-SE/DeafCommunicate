//
//  MainViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI
import Speech

@Observable
class MainViewModel: TranscriptionEngineDelegate{
    
    static let shared = MainViewModel()
    
    //Localized variables (multi language support)
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    
    //Speech recognition variables
    var isTranscribing = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    // Text variables
    var text: String = ""
    var textHistory: [String] = []
    var noTextHistory = true
    var showTextHistory: Bool = false
    var textAutoScroll: Bool = true
    var textSize: Double = 50.0
    var textStyle: TextStyle = .sfProRegular
    var isCustomTextColor: Bool = false
    var textColor: Color = Color.black
    
    // Notification variables
    var showNotification = false
    var notificationText: LocalizedStringKey? = nil
    var notificationSymbol: Image? = nil
    
    var pressMicToBeginTip = UseMicrophoneButtonTip()
    var useKeyboardTip = UseKeyboardTip()
    
    let firstTimeUsingApp = UserDefaultsManager.shared.firstTimeUsingApp()
    
    private init(){
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
    func copyTextToClipboard() {
        UIPasteboard.general.string = text
        
        Task { @MainActor in
            self.notificationText = self.textCopiedNotification
            self.notificationSymbol = Image(systemName: "document.on.document")
            
            // Show notification with animation
            withAnimation {
                self.showNotification = true
            }
        }
        
        Task {
            try await Task.sleep(for: .seconds(1.5))
            await MainActor.run {
                // Hide notification with animation
                withAnimation {
                    self.showNotification = false
                }
            }
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
        Task{
            @MainActor in
            self.isTranscribing = true
        }
    }
    
    func transcribed(_ result: String) {
        Task{
            @MainActor in
            self.text = result
        }
    }
    
    func didStopTranscription() {
        Task{
            @MainActor in
            self.isTranscribing = false
        }
    }
    
    func transcriptionEngineError(_ error: TranscriptionEngineError){
        
        Task.init(priority: .high){
            await stopTranscription()
        }
        
        var alertTitle = ""
        var alertMessage = ""
        
        switch error{
        case .speechRecognitionFailedNoSpeechDetected:
            alertTitle = "No Speech Detected"
            alertMessage = "Please try speaking louder or bringing the device closer."
        default:
            alertTitle = "Transcription Failure"
            alertMessage = error.localizedDescription
        }
        
        Task{
            @MainActor in
            self.alertTitle = alertTitle
            self.alertMessage = alertMessage
            self.showAlert = true
        }
    }
    
    
}
