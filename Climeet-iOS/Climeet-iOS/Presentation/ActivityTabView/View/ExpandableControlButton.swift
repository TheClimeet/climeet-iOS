//
//  ExpandableControlButton.swift
//  Climeet-iOS
//
//  Created by KOVI on 7/1/24.
//

import SwiftUI
import DesignSystem

struct ExpandableControlButton: View {
    @State private var isExpanded = false
        
    var body: some View {
        HStack {
             ZStack {
                 Button(action: {
                     // TODO: Pause Action
                     withAnimation {
                         isExpanded.toggle()
                     }
                 }) {
                     Image("activitytimer_pause")
                         .resizable()
                         .frame(width: 35, height: 35)
                 }
                 .frame(width: 82, height: 82)
                 .background(
                    isExpanded ? Color.text06_5 : Color.climeetMain
                 )
                 .clipShape(Circle())
                 .offset(x: isExpanded ? 100 : 0, y: 0)
                 
                 Button(action: {
                     // TODO: Play & Stop Action
                     withAnimation {
                         isExpanded.toggle()
                     }
                 }) {
                     Image(
                        isExpanded ? "activitytimer_stop" : "activitytimer_play"
                     )
                     .frame(
                        width: isExpanded ? 25 : 48.59,
                        height: isExpanded ? 25 : 48.59
                     )
                 }
                 .frame(width: 82, height: 82)
                 .background(
                    isExpanded ? Color.text06_5 : Color.climeetMain
                 )
                 .clipShape(Circle())
                 .offset(x: isExpanded ? -100 : 0, y: 0)  // A 버튼 위치 조정
             }
         }
        .animation(.linear(duration: 0.15), value: isExpanded)  // 애니메이션 적용
     }
}

#Preview {
    ExpandableControlButton()
}
