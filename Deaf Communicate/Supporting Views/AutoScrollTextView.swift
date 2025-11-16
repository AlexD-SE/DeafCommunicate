//
//  AutoScrollTextView.swift
//  Deaf Communicate
//
//  Created by Alexander Demerjian on 11/14/25.
//

import SwiftUI

struct AutoScrollingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var textSize: Double
    @Binding var textStyle: TextStyle
    @Binding var isCustomTextColor: Bool
    @Binding var textColor: Color
    @Binding var textAutoScroll: Bool

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.delegate = context.coordinator
        
        tv.text = text
        tv.textColor = isCustomTextColor == false ? UIColor.label : UIColor(textColor)
        switch textStyle {
        case .sfProRegular:
            tv.font = UIFont.systemFont(ofSize: textSize)
        default:
            tv.font = UIFont(name: textStyle.rawValue, size: textSize)
        }
        
        tv.isEditable = true
        tv.isScrollEnabled = true
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = isCustomTextColor == false ? UIColor.label : UIColor(textColor)
        switch textStyle {
        case .sfProRegular:
            uiView.font = UIFont.systemFont(ofSize: textSize)
        default:
            uiView.font = UIFont(name: textStyle.rawValue, size: textSize)
        }
        
        // Scroll to bottom if enabled and text is not empty
        if textAutoScroll && !uiView.text.isEmpty {
            let range = NSMakeRange(uiView.text.count - 1, 1)
            uiView.scrollRangeToVisible(range)
        } else {
            // Defers reseting the content offset to 0,0 until the next main thread run loop
            // This ensures that it runs after the UITextView is done with its internal updates and bringing the cursor into view
            Task { @MainActor in
                uiView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AutoScrollingTextView
        
        init(_ parent: AutoScrollingTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
