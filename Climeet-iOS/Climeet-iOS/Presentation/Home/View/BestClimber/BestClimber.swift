//
//  BestClimber.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

fileprivate
enum BestClimberSegments {
    case complete
    case time
    case level
    
    var title: String {
        switch self {
        case .complete:
            return "완등"
        case .time:
            return "시간"
        case .level:
            return "레벨"
        }
    }
}

struct BestClimber: View {
    @State private var selectedSegment: BestClimberSegments = .complete
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.bottom, 20)
            segment
                .padding(.bottom, 12)
            ranking
        }
        .padding(.horizontal, 16)
    }
    
    private var header: some View {
        HStack {
            Text("BEST 클라이머")
                .font(.climeetFontTitle4())
                .foregroundStyle(Color.text00)
            Spacer()
            ShowAllButton()
        }
    }
    
    private var segment: some View {
        HStack(spacing: 0) {
            SegmentButton(selectedSegment: $selectedSegment, segment: .complete)
            SegmentButton(selectedSegment: $selectedSegment, segment: .time)
            SegmentButton(selectedSegment: $selectedSegment, segment: .level)
        }
        .background {
            RoundedRectangle(cornerRadius: 80)
                .foregroundStyle(Color.text07)
        }
    }
    
    private var ranking: some View {
        HStack(alignment: .bottom, spacing: 6) {
            VStack(spacing: 18) {
                RankingProfile()
                RankingBar(rank: 2, height: 72)
            }
            VStack(spacing: 18) {
                RankingProfile(isFirst: true)
                RankingBar(rank: 1, height: 104)
            }
            VStack(spacing: 18) {
                RankingProfile()
                RankingBar(rank: 3, height: 56)
            }
        }
        .padding(.top, 32)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.text07)
        }
    }
}

fileprivate
struct SegmentButton: View {
    @Binding var selectedSegment: BestClimberSegments
    let segment: BestClimberSegments
    
    // TODO: 탭 시 전환되는 기능 구현 필요
    var body: some View {
        Text(segment.title)
            .font(.climeetFontParagraph4())
            .frame(maxWidth: .infinity)
            .foregroundStyle(selectedSegment == segment ? Color.text09 : Color.text00)
            .padding(.vertical, 9)
            .background {
                RoundedRectangle(cornerRadius: 80)
                    .foregroundStyle(
                        selectedSegment == segment ? Color.climeetMain : Color.text07
                    )
            }
            .onTapGesture {
                selectedSegment = segment
            }
            .animation(.easeInOut, value: selectedSegment)
    }
}

fileprivate
struct RankingProfile: View {
    let isFirst: Bool
    
    init(isFirst: Bool = false) {
        self.isFirst = isFirst
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.contentShortsNotselect)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .padding(.bottom, 12)
                .background {
                    Image(.homeCrown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 24)
                        .offset(y: -36)
                        .opacity(isFirst ? 1 : 0)
                }
            Text("켈리")
                .font(.climeetFontParagraph1())
                .foregroundStyle(Color.starNotFilled)
                .padding(.bottom, 6)
            Text("10개 완등")
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.text05)
        }
    }
}

fileprivate
struct RankingBar: View {
    let rank: Int
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.text06)
            .frame(height: height)
            .overlay {
                VStack {
                    Spacer()
                    Text("\(rank)")
                        .font(.climeetFontParagraph4())
                        .foregroundStyle(rank == 1 ? Color.climeetMain : Color.text03)
                }
                .padding(.bottom, 12)
            }
    }
}

#Preview {
    BestClimber()
        .background(Color.climeetBackground)
}
