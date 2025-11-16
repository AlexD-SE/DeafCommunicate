//
//  DictationView.swift
//  Deaf Communicate
//
//  Created by Alexander Demerjian on 10/27/25.
//

import SwiftUI

struct DictationView: View {
    @Bindable var model: MainViewModel
    var geometryHeight: CGFloat
    @FocusState private var textEditorFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                AutoScrollingTextView(text: $model.text, textSize: $model.textSize, textStyle: $model.textStyle, isCustomTextColor: $model.isCustomTextColor, textColor: $model.textColor, textAutoScroll: $model.textAutoScroll)
                    .background(.gray.opacity(0.3))
                    .frame(height: textEditorFocused == true ? geometryHeight*0.9 : geometryHeight*0.79)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2)
                    }
                    .padding([.leading, .trailing])
                    .padding(.top, 5)
                    .focused($textEditorFocused)
                    .popoverTip(model.useKeyboardTip)
                    .onTapGesture{
                        model.useKeyboardTip.invalidate(reason: .actionPerformed)
                    }
            }
            .scrollDismissesKeyboard(.interactively)
            
            //MARK: Microphone Button
            if !Locale.current.identifier.contains("hy_"){
                
                if textEditorFocused == false {
                    
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
                    .padding(.bottom, 5)
                }
            }
        }
    }
}
