//
//  FloorSegmentedControl.swift
//  Climeet-iOS
//
//  Created by KOVI on 7/3/24.
//

import SwiftUI
import DesignSystem

struct FloorSegmentedControl: View {
    
    @Binding var selectedIndex: Int
    @State private var frames = Array<CGRect>(repeating: .zero, count: 20)
    
    private let titles: [String] = ["1층", "2층"]
    private let selectedItemColor: Color = .climeetMain
    private let backgroundColor: Color = .text06_5
    private let selectedItemFontColor: Color = .levelBlack
    private let defaultItemFontColor: Color = .levelWhite
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 10) {
                    ForEach(self.titles.indices, id: \.self) { index in
                        Text(self.titles[index])
                            .font(.climeetFontParagraph4())
                            .foregroundColor(
                                selectedIndex == index ? selectedItemFontColor
                                : defaultItemFontColor
                            )
                            .onTapGesture {
                                selectedIndex = index
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 31)
                            .background {
                                GeometryReader { geometry in
                                    Color.clear.onAppear {
                                        self.setFrame(index: index, frame: geometry.frame(in: .global))
                                    }
                                }
                            }
                    }
                }
                .background(alignment: .leading) {
                    Capsule()
                        .fill(selectedItemColor)
                        .frame(width: self.frames[selectedIndex].width, height: 31)
                        .offset(x: self.frames[selectedIndex].minX - self.frames[0].minX)
                }
            }
            .background(backgroundColor)
            .animation(.spring(), value: selectedIndex)
        }
        .cornerRadius(100)
    }
    
    private func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
}

//#Preview {
//    FloorSegmentedControl()
//}
