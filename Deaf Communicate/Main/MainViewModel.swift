//
//  MainViewModel.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/25/23.
//

import Foundation
import SwiftUI
import Speech

class MainViewModel: ObservableObject{
    
    //Localized variables (multi language support)
    let textCopiedNotification: LocalizedStringKey = "Text Copied Notification"
    let instructionMessageOne:LocalizedStringKey = "Instruction Message One"
    
    //Speech recognition variables
    private let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    @Published var isRecording = false
    
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
    @Published var notificationSymbol: String? = nil
    
    
    /// Starts speech recognition by using the AVAudioEngine to get microphone input and process it through an SFSpeechRecognizer instance for the current locale.
    func startSpeechRecognition(){
        
        // Verify that there is a speech recognizer instance for the current locale
        guard let speechRecognizer = speechRecognizer else {return}
        
        // Check if the Speech Recognizer is available
        guard speechRecognizer.isAvailable == true else {return}
        
        // Create recognition request for audio buffers to enable real-time processing of audio
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Configure recognition request
        recognitionRequest.shouldReportPartialResults = true
        speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            if let result = result {
                
                // Update view with transcribed text
                DispatchQueue.main.async{
                    self.text = result.bestTranscription.formattedString
                }
                
            } else if let error = error {
                
                print(error.localizedDescription)
                
            }
        }
        
        // Get the input node of the audio engine
        let inputNode = audioEngine.inputNode
        
        // Get the format that the input node will produce
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Install callback on the input node with the matching format that will get the audio buffer data as it comes in
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            
            // Append the audio buffer data to the recognition request so that it can be processed by its recognition task
            recognitionRequest.append(buffer)
        }
        
        // Prepare the audio engine
        audioEngine.prepare()
        
        // Try to start the audio engine and update the isRecording variable for the view
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine failed to start")
        }
    }
    
    /// Stops speech recognition. This will stop the AVAudioEngine instance from processing microphone input and remove the callback on its input node.
    func stopSpeechRecognition(){
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        DispatchQueue.main.async{
            self.isRecording = false
        }
    }
    
    /// Configures the user defaults to restore the user's past font settings.
    func configureUserDefaults(){
        
        if let fontSize = UserDefaults.standard.object(forKey: "fontSize") as? Double{
            self.fontSize = fontSize
        }else{
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
        
        if let fontStyle = UserDefaults.standard.object(forKey: "fontStyle") as? String{
            self.fontStyle = fontStyle
        }else{
            UserDefaults.standard.set(fontStyle, forKey: "fontStyle")
        }
         
        if let isCustomFontColor = UserDefaults.standard.object(forKey: "isCustomFontColor") as? Bool{
            self.isCustomFontColor = isCustomFontColor
        }else{
            UserDefaults.standard.set(isCustomFontColor, forKey: "isCustomFontColor")
        }
        
        if let fontColorInt = UserDefaults.standard.object(forKey: "fontColorInt") as? Int{
            fontColor = fontColorInt.determineColor()
        }else{
            UserDefaults.standard.set(fontColor.determineInt(), forKey: "fontColorInt")
        }
    }
    
    /// Copies the text to the system wide general pasteboard.
    func copyTextToClipboard(){
        
        UIPasteboard.general.string = text
        
        DispatchQueue.main.async{
            self.notificationText = self.textCopiedNotification
            self.notificationSymbol = "CopyIcon"
            
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
    
}
