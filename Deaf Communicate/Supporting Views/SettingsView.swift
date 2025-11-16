//
//  SettingsView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/26/22.
//

import SwiftUI

enum TextStyle: String, CaseIterable, Identifiable {
    case sfProRegular = "SF Pro Regular"
    case timesNewRoman = "Times New Roman"
    case timesNewRomanBold = "Times New Roman Bold"
    case arial = "Arial"
    case arialBold = "Arial Bold"
    case bradleyHandBold = "Bradley Hand Bold"
    case copperplateBold = "Copperplate Bold"
    case chalkboardSERegular = "Chalkboard SE Regular"
    case chalkboardSEBold = "Chalkboard SE Bold"
    case chalkduster = "Chalkduster"
    case courier = "Courier"
    case courierBold = "Courier Bold"
    case noteworthyLight = "Noteworthy Light"
    case noteWorthyBold = "Noteworthy Bold"
    case optimaRegular = "Optima Regular"
    case optimaBold = "Optima Bold"
    case papyrus = "Papayrus"
    case partyLETPlain = "Party LET Plain"
    case rockwell = "Rockwell"
    case rockwellBold = "Rochwell Bold"
    case savoyeLETPlain = "Savoye LET Plain"
    case symbol = "Symbol"
    case verdana = "Verdana"
    case verdanaBold = "Verdana Bold"
    
    var id: Self { self }
}

struct SettingsView: View{
    
    //General variables
    @Bindable var model: MainViewModel
    let colors = [Color.black, Color.white, Color.blue, Color.red, Color.yellow, Color.orange, Color.green]
    @State var textSize = 50.0
    @State var textStyle: TextStyle = .sfProRegular
    @State var isCustomTextColor = false
    @State var textColor = Color.black
    
    //Localized variables (for multi language support)
    let settingsViewTitle : LocalizedStringKey = "Settings View Title"
    let settingsAutoScrollText : LocalizedStringKey = "Settings Text Auto Scroll"
    let settingsTextOne : LocalizedStringKey = "Settings Text One"
    let settingsTextTwo: LocalizedStringKey = "Settings Text Two"
    let settingsTextStyleOne : LocalizedStringKey = "Settings Text Style One"
    let settingsTextStyleTwo : LocalizedStringKey = "Settings Text Style Two"
    let settingsTextColorOne : LocalizedStringKey = "Settings Text Color One"
    let settingsTextColorTwo : LocalizedStringKey = "Settings Text Color Two"
    
    init(model: MainViewModel){
        UITextView.appearance().backgroundColor = .clear
        self.model = model
    }
    
    var body: some View{
        
        Text(settingsTextStyleTwo)
            .frame(height:100)
            .font(Font.custom(textStyle.rawValue, size: textSize))
            .foregroundColor(textColor)
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .padding()
        
        Button(action: {
            textSize = 50.0
            textStyle = .sfProRegular
            textColor = Color.black
            isCustomTextColor = false
            model.textAutoScroll = true
        }, label: {
            Image(systemName: "arrow.counterclockwise")
            Text(settingsTextTwo)
        })
        .foregroundStyle(.red)
        .buttonStyle(.bordered)
        
        List{
            
            Section{
                
                HStack{
                    Toggle(settingsAutoScrollText, isOn: $model.textAutoScroll)
                }
                
                HStack{
                    Text(settingsTextOne)
                    Spacer()
                    Text("\(textSize, specifier: "%.0f")")
                }
                
                HStack{
                    Image(systemName: "minus")
                    Slider(value:$textSize, in:25...150)
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
                    Picker(settingsTextStyleOne, selection:$textStyle){
                        ForEach(TextStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Toggle(settingsTextColorOne, isOn: $isCustomTextColor)
            }
            
            if isCustomTextColor{
                Picker("", selection: $textColor){
                    ForEach(colors, id:\.self){ color in
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
            textSize = model.textSize
            textStyle = model.textStyle
            isCustomTextColor = model.isCustomTextColor
            textColor = model.textColor
        })
        .onDisappear(perform: {
            //update user defaults
            UserDefaults.standard.set(textSize, forKey: "textSize")
            UserDefaults.standard.set(textStyle.rawValue, forKey: "textStyle")
            UserDefaults.standard.set(isCustomTextColor, forKey: "isCustomTextColor")
            UserDefaults.standard.set(textColor.determineInt(), forKey: "textColorInt")
            
            //update current text settings
            model.textSize = textSize
            model.textStyle = textStyle
            model.isCustomTextColor = isCustomTextColor
            model.textColor = textColor
        })
        
    }
    
}


