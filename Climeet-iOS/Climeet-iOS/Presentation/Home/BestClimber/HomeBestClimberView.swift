//
//  HomeBestClimberView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

fileprivate
enum BestClimberSegments {
    case clear
    case time
    case level
    
    var title: String {
        switch self {
        case .clear:
            return "완등"
        case .time:
            return "시간"
        case .level:
            return "레벨"
        }
    }
}

struct HomeBestClimberView: View {
    @Bindable var store: StoreOf<HomeBestClimberReducer>
    @State private var selectedSegment: BestClimberSegments = .clear
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.bottom, 20)
            segment
                .padding(.bottom, 12)
            ranking
        }
        .padding(.horizontal, 16)
        .onFirstAppear {
            store.send(.onFirstApear)
        }
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
            SegmentButton(selectedSegment: $selectedSegment, segment: .clear)
            SegmentButton(selectedSegment: $selectedSegment, segment: .time)
            SegmentButton(selectedSegment: $selectedSegment, segment: .level)
        }
        .background {
            RoundedRectangle(cornerRadius: 80)
                .foregroundStyle(Color.text07)
        }
    }
   
    @ViewBuilder
    private var ranking: some View {
        if !store.bestClearClimbers.isEmpty {
            switch selectedSegment {
            case .clear:
                clearRanking
                
            case .time:
                    timeRanking
                
            case .level:
                levelRanking
            }
        }
    }
    
    private var clearRanking: some View {
        HStack(alignment: .bottom, spacing: 6) {
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestClearClimbers[safe: 1]?.profileName ?? " ",
                    profileImageURL: store.bestClearClimbers[safe: 1]?.profileImageURL ?? " ",
                    description: store.bestClearClimbers[safe: 1]?.description ?? " "
                )
                RankingBar(rank: 2, height: 72)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    isFirst: true,
                    name: store.bestClearClimbers[safe: 0]?.profileName ?? " ",
                    profileImageURL: store.bestClearClimbers[safe: 0]?.profileImageURL ?? " ",
                    description: store.bestClearClimbers[safe: 0]?.description ?? " "
                )
                RankingBar(rank: 1, height: 104)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestClearClimbers[safe: 2]?.profileName ?? " ",
                    profileImageURL: store.bestClearClimbers[safe: 2]?.profileImageURL ?? " ",
                    description: store.bestClearClimbers[safe: 2]?.description ?? " "
                )
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
    
    private var timeRanking: some View {
        HStack(alignment: .bottom, spacing: 6) {
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestTimeClimbers[safe: 1]?.profileName ?? " ",
                    profileImageURL: store.bestTimeClimbers[safe: 1]?.profileImageURL ?? " ",
                    description: store.bestTimeClimbers[safe: 1]?.description ?? " "
                )
                RankingBar(rank: 2, height: 72)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    isFirst: true,
                    name: store.bestTimeClimbers[safe: 0]?.profileName ?? " ",
                    profileImageURL: store.bestTimeClimbers[safe: 0]?.profileImageURL ?? " ",
                    description: store.bestTimeClimbers[safe: 0]?.description ?? " "
                )
                RankingBar(rank: 1, height: 104)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestTimeClimbers[safe: 2]?.profileName ?? " ",
                    profileImageURL: store.bestTimeClimbers[safe: 2]?.profileImageURL ?? " ",
                    description: store.bestTimeClimbers[safe: 2]?.description ?? " "
                )
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
    
    private var levelRanking: some View {
        HStack(alignment: .bottom, spacing: 6) {
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestLevelClimbers[safe: 1]?.profileName ?? " ",
                    profileImageURL: store.bestLevelClimbers[safe: 1]?.profileImageURL ?? " ",
                    description: store.bestLevelClimbers[safe: 1]?.description ?? " "
                )
                RankingBar(rank: 2, height: 72)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    isFirst: true,
                    name: store.bestLevelClimbers[safe: 0]?.profileName ?? " ",
                    profileImageURL: store.bestLevelClimbers[safe: 0]?.profileImageURL ?? " ",
                    description: store.bestLevelClimbers[safe: 0]?.description ?? " "
                )
                RankingBar(rank: 1, height: 104)
            }
            VStack(spacing: 0) {
                RankingProfile(
                    name: store.bestLevelClimbers[safe: 2]?.profileName ?? " ",
                    profileImageURL: store.bestLevelClimbers[safe: 2]?.profileImageURL ?? " ",
                    description: store.bestLevelClimbers[safe: 2]?.description ?? " "
                )
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
    let name: String
    let profileImageURL: String
    let description: String
    
    init(
        isFirst: Bool = false,
        name: String,
        profileImageURL: String,
        description: String
    ) {
        self.isFirst = isFirst
        self.name = name
        self.profileImageURL = profileImageURL
        self.description = description
    }
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: profileImageURL))
                .placeholder({
                    Color.gray
                })
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .padding(.bottom, 12)
                .background {
                    Image(.homeCrown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 24)
                        .offset(y: -36)
                        .opacity(isFirst ? 1 : 0)
                }
            Text(name)
                .font(.climeetFontParagraph1())
                .foregroundStyle(Color.starNotFilled)
                .padding(.bottom, 6)
            Text(description)
                .font(.climeetFontCaptionText3())
                .foregroundStyle(Color.text05)
                .padding(.bottom, 18)
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
    let store = Store(initialState: HomeBestClimberReducer.State(), reducer: { HomeBestClimberReducer() })
    HomeBestClimberView(store: store)
        .background(Color.climeetBackground)
}
