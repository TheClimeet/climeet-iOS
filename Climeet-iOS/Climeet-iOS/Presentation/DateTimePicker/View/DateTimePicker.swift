//
//  DateTimePicker.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/12/24.
//

import Foundation
import SwiftUI

struct DateTimePicker: UIViewRepresentable {
    @Binding var selection: Date
    var textColor: UIColor
    var pickerMode: UIDatePicker.Mode
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = pickerMode
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.timeZone = TimeZone(identifier: "Asia/Seoul")
        picker.setValue(textColor, forKey: "textColor")
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.dateChanged(_:)),
            for: .valueChanged
        )
        picker.date = selection
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selection
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: DateTimePicker
        
        init(_ parent: DateTimePicker) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selection = sender.date
        }
    }
}
