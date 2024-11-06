//
//  Stepper.swift
//  Climeet-iOS
//
//  Created by KOVI on 11/5/24.
//

import SwiftUI
import DesignSystem
import Kingfisher

struct CardStyleStepper: View {
    
    var filteredRoute: FilteredRoute?
    var attemptCount: Int
    var minusButtonAction: (() -> Void)?
    var plusButtonAction: (() -> Void)?
    
    var body: some View {
        if let filteredRoute = filteredRoute {
            HStack {
                RouteChip(filteredRoute: filteredRoute)
                    .frame(width: 109, height: 134)
                
                VStack {
                    Text("도전 횟수")
                        .foregroundColor(Color.white)
                        .font(Font.climeetFontParagraph1())
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    VStack {
                        AttemptStepper(
                            attemptCount: attemptCount,
                            minusButtonAction: { minusButtonAction?() },
                            plusButtonAction: { plusButtonAction?() }
                        )
                        .padding(.bottom, 25)
                        
                        FillButton(
                            size: 35,
                            text: "완등했어요",
                            font: Font.climeetFontParagraph4(),
                            action: { },
                            disabled: true
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
            }
        }
    }
}

struct CellStyleStepper: View {
    
    var filteredRoute: FilteredRoute?
    var attemptCount: Int
    var minusButtonAction: (() -> Void)?
    var plusButtonAction: (() -> Void)?
    
    var body: some View {
        
        if let filteredRoute = filteredRoute {
            HStack {
                RouteChip(filteredRoute: filteredRoute)
                    .frame(width: 52, height: 66)
                
                VStack {
                    Text("도전")
                        .foregroundColor(Color.white)
                        .font(Font.climeetFontParagraph1())
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    AttemptStepper(
                        attemptCount: attemptCount,
                        minusButtonAction: { minusButtonAction?() },
                        plusButtonAction: { plusButtonAction?() }
                    )
                    .padding(.bottom, 25)
                }
                
                VStack {
                    Text("완등")
                    Button(action: {
                        
                    }, label: {
                        
                    })
                }
                
                Button(action: {
                    
                }, label: {
                    
                })
            }
            .background(Color.black)
        }
    }
}

#Preview {
    CellStyleStepper(filteredRoute: FilteredRoute(
        routeId: 4321,
        sectorId: 361,
        sectorName: "서울",
        climeetDifficultyName: "V2",
        difficulty: 3,
        gymDifficultyName: "V2",
        gymDifficultyColor: "#F34040",
        routeImageUrl:  "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/default/profile.jpg",
        holdColor: "빨강"),
                     attemptCount: 10,
                     minusButtonAction: nil,
                     plusButtonAction: nil
    )
}

fileprivate struct RouteChip: View {
    
    var filteredRoute: FilteredRoute?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if
                    let filteredRoute = filteredRoute,
                    let routeImageUrl = filteredRoute.routeImageUrl,
                    let climeetDifficultyName = filteredRoute.climeetDifficultyName,
                    let gymDifficultyColor = filteredRoute.gymDifficultyColor
                {
                    KFImage(URL(string: routeImageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height * 3 / 4)
                    
                    ZStack(alignment: .leading) {
                        Color.levelBlack
                        Text(climeetDifficultyName)
                            .foregroundColor(Color(hex: gymDifficultyColor))
                            .font(.climeetFontCaptionText3())
                            .frame(height: geometry.size.width / 4)
                            .padding(.leading, 5)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.climeetMain, lineWidth: 2)
            )
        }
    }
}

fileprivate struct AttemptStepper: View {
    var attemptCount: Int
    let minusButtonAction: () -> Void
    let plusButtonAction: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                minusButtonAction()
            }, label: {
                Image("activitytimer_minus")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Text("\(attemptCount)")
                .foregroundColor(Color.white)
                .font(Font.climeetFontTitle3_5())
                .monospacedDigit()
            
            Button(action: {
                plusButtonAction()
            }, label: {
                Image("activitytimer_plus")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
        }
    }
}
