//
//  NotificationView.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 9/8/23.
//

import SwiftUI

struct NotificationView: View {
    
    public var symbol: Image?
    public var text: LocalizedStringKey?
    @Environment(\.colorScheme) var appearance
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .frame(width:150, height:100)
                .foregroundColor(appearance == .light ? .white:.black)
                .backgroundStyle(.thinMaterial)
                .cornerRadius(8)
            VStack{
                if let symbol = symbol{
                    symbol
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                if let text = text {
                    Text(text)
                }
            }
        }
    }
}
