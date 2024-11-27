//
//  CutomAccessSelectButton.swift
//  Climeet-iOS
//
//  Created by mac on 7/11/24.
//

import SwiftUI

struct CutomAccessSelectToggle: View {
    let index: Int
    @Binding var selectedToggle: Int
    @State private var selected: Bool = false
    
    var body: some View {
        Button(action: {
            // Select this toggle
            if selectedToggle != index {
                selectedToggle = index
            }
            
            withAnimation {
                selected.toggle()
            }
        }) {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(.climeetMain, lineWidth: 5)
                    .fill(.climeetBackground)
                    .frame(width: 24, height: 24)
                
                Circle()
                    .fill(selectedToggle == index ? .climeetMain : .climeetBackground)
                    .frame(width: 18, height: 18)
            }
        }
        .padding(5)
    }
}
