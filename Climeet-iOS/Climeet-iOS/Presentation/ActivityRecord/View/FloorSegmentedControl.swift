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
    @State private var frames = Array<CGRect>(repeating: .zero, count: 2) 
    
    private let titles: [String] = ["1층", "2층"]
    private let selectedItemColor: Color = .climeetMain
    private let backgroundColor: Color = .text06_5
    private let selectedItemFontColor: Color = .levelBlack
    private let defaultItemFontColor: Color = .levelWhite
    
    var body: some View {
        GeometryReader { geometry in // GeometryReader 추가
            ZStack {
                Capsule()
                    .fill(backgroundColor)
                
                Capsule()
                    .fill(selectedItemColor)
                    .frame(width: geometry.size.width / CGFloat(titles.count) - 10)
                    .offset(x: calculateOffset(geometry: geometry))
                
                HStack(spacing: 10) {
                    ForEach(titles.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedIndex = index
                            }
                        }) {
                            Text(titles[index])
                                .font(.climeetFontParagraph4())
                                .foregroundColor(
                                    selectedIndex == index ? selectedItemFontColor
                                    : defaultItemFontColor
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 31)
                    }
                }
            }
        }
        .frame(height: 31)
        .clipShape(Capsule())
    }
    
    private func calculateOffset(geometry: GeometryProxy) -> CGFloat {
        let buttonWidth = geometry.size.width / CGFloat(titles.count)
        let offset = CGFloat(selectedIndex) * buttonWidth
        return offset - geometry.size.width / 2 + buttonWidth / 2
    }
}

//#Preview {
//    @Previewable @State var selectedIndex: Int = 2
//    
//    FloorSegmentedControl(selectedIndex: $selectedIndex)
//}
