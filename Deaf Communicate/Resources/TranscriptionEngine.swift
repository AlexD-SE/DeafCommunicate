//
//  TranscriptionEngine.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/26/24.
//

import Foundation
import AVFAudio
import Speech
import UIKit

public protocol TranscriptionEngineDelegate: AnyObject {
    func didStartTranscription()
    func transcribed(_ result: String)
    func didStopTranscription()
    func transcriptionEngineError(_ error: TranscriptionEngineError)
}

public class TranscriptionEngine: NSObject{
    
    private override init(){}
    public static let shared = TranscriptionEngine()
    public var siriInvoked: Bool = false
    
    public weak var delegate: TranscriptionEngineDelegate?
    
    private var audioEngine: AVAudioEngine?
    private var speechRecognizer: SFSpeechRecognizer?
    private var speechAudioBufferRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private var microphoneIsInUseByOtherApp: Bool = false
    
    func prepare(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionInterruption), name: AVAudioSession.interruptionNotification,
                                                   object: AVAudioSession.sharedInstance())
        
    }
    
    @objc func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            
            //make sure to end the transcription as the AVAudioSession has been interrupted by another app
            Task.init(){
                await stopTranscription()
            }
        default:
            break
        }
    }
    
    
    /// Starts transcription by using the AVAudioEngine to get microphone input and process it through an SFSpeechRecognizer instance for the current locale.
    func startTranscription() async{
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: [.duckOthers])
        } catch {
            self.delegate?.transcriptionEngineError(.audioSessionConfigurationFailed)
            return
        }
        
        do{
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            self.delegate?.transcriptionEngineError(.audioSessionSetActiveFailed)
            return
        }
        
        // Attempt to create a SFSpeechRecognizer for the current locale
        speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
        
        // Verify that the speech recognizer instance isn't null
        guard let speechRecognizer = speechRecognizer else {
            delegate?.transcriptionEngineError(.speechRecognizerNotFoundForCurrentLocale)
            return
        }
                
        // Verify that the speech recognizer is available
        guard speechRecognizer.isAvailable else {
            
            delegate?.transcriptionEngineError(.speechRecognizerNotAvailable)
            return
        }
        
        // Create an SFSpeechAudioBufferRecognitionRequest instance
        speechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let speechAudioBufferRecognitionRequest = speechAudioBufferRecognitionRequest else {
            return
        }
        
        // Create an AudioEngine instance
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            return
        }
        
        // Get the format of the recording that the Audio Engine will produce
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Ensure that the recording format is correct for the speech recognizer
        guard recordingFormat.sampleRate == 48000, recordingFormat.channelCount == 1 else {
            delegate?.transcriptionEngineError(.invalidRecordingFormat)
            return
        }
        
        // Install callback on the input node with the matching format that will get the audio buffer data as it comes in
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            
            // Append the audio buffer data to the recognition request so that it can be processed by its recognition task
            speechAudioBufferRecognitionRequest.append(buffer)
        }
        
        speechRecognizer.recognitionTask(with: speechAudioBufferRecognitionRequest) { result, error in
            guard let nsError = error as NSError? else {
                if let result = result{
                    self.delegate?.transcribed(result.bestTranscription.formattedString)
                }
                return
            }
            
            // If error indicates no speech was detected, present no speech detected error
            if nsError.domain == "kAFAssistantErrorDomain", nsError.code == 1110 {
                self.delegate?.transcriptionEngineError(.speechRecognitionFailedNoSpeechDetected)
                return
            }
            
            self.delegate?.transcriptionEngineError(.speechRecognitionFailed)
        }
        
        // Prepare the audio engine
        audioEngine.prepare()
        
        // Try to start the audio engine and update the isRecording variable for the view
        do {
            try audioEngine.start()
        }catch{
            delegate?.transcriptionEngineError(.avAudioEngineStartFailed)
            return
        }
        
        delegate?.didStartTranscription()
        
    }
    
    /// Stops the transcription, performs cleanup, and informs the delegate that the transcription has stopped.
    func stopTranscription() async{
        
        //signal to the speech recognizer through the request that this is the end of the audio
        speechAudioBufferRecognitionRequest?.endAudio()
        
        //cancel the speech recognition task
        speechRecognitionTask?.cancel()
        
        //stop the audio engine and remove the callback on its bus
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        //try to set the audio session to inactive
        do{
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("An error occurred trying to set the audio session to inactive.")
        }
        
        //nil the request, task, and recognizer objects
        speechAudioBufferRecognitionRequest = nil
        speechRecognitionTask = nil
        speechRecognizer = nil
        
        //inform the delegate that transcription has stopped
        delegate?.didStopTranscription()
    }
    
}

public enum TranscriptionEngineError: Error, LocalizedError{
    case audioSessionConfigurationFailed
    case audioSessionSetActiveFailed
    case invalidRecordingFormat
    case speechRecognizerNotFoundForCurrentLocale
    case speechRecognizerNotAvailable
    case speechRecognitionFailed
    case speechRecognitionFailedNoSpeechDetected
    case avAudioEngineStartFailed
    
    public var errorDescription: String? {
        switch self {
        case .audioSessionConfigurationFailed:
            return "Failed to configure the AVAudioSession."
        case .audioSessionSetActiveFailed:
            return "Failed to set the status of the AVAudioSession to active."
        case .invalidRecordingFormat:
            return "The current recording format is not supported by the speech recognizer."
        case .speechRecognizerNotFoundForCurrentLocale:
            return "No speech recognizer was found that supports the current locale."
        case .speechRecognizerNotAvailable:
            return "Speech recognition services are not available."
        case .speechRecognitionFailed:
            return "Speech recognizer failed to process the audio from the audio input."
        case .speechRecognitionFailedNoSpeechDetected:
            return "Speech recognizer failed to process the audio from the audio input because there was no speech detected."
        case .avAudioEngineStartFailed:
            return "Failed to start the AVAudioEngine."
        
        }
    }
}
