//
//  SettingsView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

struct SettingsView: View{
    
    //General variables
    @EnvironmentObject private var deafCommunicateModel: MainViewModel
    let colors = [Color.black, Color.white, Color.blue, Color.red, Color.yellow, Color.orange, Color.green]
    let fontStyles = ["SF Pro Regular", "Times New Roman",
    "Times New Roman Bold", "Arial", "Arial Bold", "Bradley Hand Bold", "Copperplate Bold", "Chalkboard SE Regular", "Chalkboard SE Bold", "Chalkduster", "Courier", "Courier Bold", "Noteworthy Light", "Noteworthy Bold", "Optima Regular", "Optima Bold", "Papyrus", "Party LET Plain", "Rockwell", "Rockwell Bold", "Savoye LET Plain", "Symbol", "Verdana", "Verdana Bold"]
    @State var fontSize = 50.0
    @State var fontStyle = "SF Pro Regular"
    @State var isCustomFontColor = false
    @State var fontColor = Color.black
    
    //Localized variables (for multi language support)
    let settingsViewTitle : LocalizedStringKey = "Settings View Title"
    let settingsFontTextOne : LocalizedStringKey = "Settings Font Text One"
    let settingsFontTextTwo : LocalizedStringKey = "Settings Font Text Two"
    let settingsFontTextThree: LocalizedStringKey = "Settings Font Text Three"
    let settingsFontStyleOne : LocalizedStringKey = "Settings Font Style One"
    let settingsFontStyleTwo : LocalizedStringKey = "Settings Font Style Two"
    let settingsFontStyleThree : LocalizedStringKey = "Settings Font Style Three"
    let settingsFontColorOne : LocalizedStringKey = "Settings Font Color One"
    let settingsFontColorTwo : LocalizedStringKey = "Settings Font Color Two"
    let settingsFontColorThree : LocalizedStringKey = "Settings Font Color Three"
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View{
        
        Text(settingsFontStyleThree)
            .frame(height:100)
            .font(Font.custom(fontStyle, size: fontSize))
            .foregroundColor(fontColor)
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .padding()
        
        Button(action:{
            fontSize = 50.0
            fontStyle = "SF Pro Regular"
            fontColor = Color.black
            isCustomFontColor = false}){
                
            Image(systemName: "arrow.counterclockwise")
            Text(settingsFontTextThree)
        }
        .foregroundStyle(.red)
        .buttonStyle(.bordered)
        
        List{
            
            Section{
                
                HStack{
                    Text(settingsFontTextOne)
                    Spacer()
                    Text("\(fontSize, specifier: "%.0f")")
                }
                
                HStack{
                    Image(systemName: "minus")
                    Slider(value:$fontSize, in:25...150)
                        .padding()
                        .accentColor(Color.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(lineWidth: 1.0)
                                .foregroundColor(Color.gray)
                        )
                    Image(systemName: "plus")
                }
            }
            
            Section{
                
                HStack{
                    
                    Picker(settingsFontStyleOne, selection:$fontStyle){
                            
                        ForEach(fontStyles, id:\.self){
                            
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Toggle(settingsFontColorOne, isOn: $isCustomFontColor)
                
            }
            
            if isCustomFontColor{
                
                Picker("", selection: $fontColor){
                    
                    ForEach(colors, id:\.self){
                        
                        color in
                        
                        HStack{
                            Rectangle()
                                .border(Color.gray, width: 2)
                                .foregroundStyle(color)
                                .frame(width: 20, height: 10)
                            
                            Text(color.description)
                        }
                        
                    }
                    
                }
                .pickerStyle(.inline)
            }
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle(settingsViewTitle)
        .onAppear(perform: {
            
            fontSize = deafCommunicateModel.fontSize
            fontStyle = deafCommunicateModel.fontStyle
            isCustomFontColor = deafCommunicateModel.isCustomFontColor
            fontColor = deafCommunicateModel.fontColor
            
        })
        .onDisappear(perform: {
            
            //update user defaults
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
            UserDefaults.standard.set(fontStyle, forKey: "fontStyle")
            UserDefaults.standard.set(isCustomFontColor, forKey: "isCustomFontColor")
            UserDefaults.standard.set(fontColor.determineInt(), forKey: "fontColorInt")
            
            //update current text settings
            deafCommunicateModel.fontSize = fontSize
            deafCommunicateModel.fontStyle = fontStyle
            deafCommunicateModel.isCustomFontColor = isCustomFontColor
            deafCommunicateModel.fontColor = fontColor
            
        })
        
    }
    
}


