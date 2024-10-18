//
//  RootSelectionView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/13/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct RouteSelectionView: View {
    
    @Bindable var store: StoreOf<RouteSelectionReducer>
    
    var body: some View {
        VStack {
//            if shouldShowFloorControl {
//                FloorSegmentedControl(
//                    selectedIndex: $store.selectedFloor.sending(\.floorChangeSegmentedControlTapped)
//                )
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 13)
//            }
//            selectedFloorImageView
//            sectorScrollView
//            difficultyScrollView
//            filteredRoutesScrollView
        }
    }
    
    private var shouldShowFloorControl: Bool {
        if
            let gymRoutes = store.gymRoutes,
            let floorLayout = gymRoutes.floorLayout,
            floorLayout.count >= 2
        {
            return true
        }
        return false
    }
    
    @ViewBuilder
    private var selectedFloorImageView: some View {
        if
            let gymRoutes = store.gymRoutes,
            let floorLayout = gymRoutes.floorLayout,
            let selectedFloorLayout = floorLayout.first(where: { $0.floor == store.selectedFloor + 1 }),
            let selectedFloorImageURL = selectedFloorLayout.imgUrl
        {
            KFImage(URL(string: selectedFloorImageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 132)
                .frame(maxWidth: .infinity)
                .cornerRadius(5)
        } else {
            EmptyView()
        }
    }
    
    private var sectorScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 9) {
                if
                    let gymRoutes = store.gymRoutes,
                    let filteredSectors = gymRoutes.sectors?.filter({ $0.floor == store.selectedFloor + 1 })
                {
                    ForEach(filteredSectors) { sector in
                        Button(action: {
                            store.send(.sectorChangeButtonTapped(sector))
                        }, label: {
                            Text(sector.name ?? "")
                                .font(.climeetFontParagraph5())
                        })
                        .padding(.horizontal, 16)
                        .padding(.top, 5.5)
                        .padding(.bottom, 6.5)
                        .background()
                        .background(
                            store.selectedSector.sectorId == sector.sectorId ? Color.climeetMain
                            : Color.text06
                        )
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(
                            store.selectedSector.sectorId == sector.sectorId ? Color.levelBlack
                            : Color.levelWhite
                        )
                    }
                }
            }
        }
        .scrollIndicators(.never)
    }
    
    private var difficultyScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 9) {
                if
                    let gymRoutes = store.gymRoutes,
                    let difficultyList = gymRoutes.difficultyList
                {
                    ForEach(difficultyList) { difficulty in
                        Button(action: {
                            store.send(.difficultyChangeButtonTapped(difficulty))
                        }, label: {
                            Text(difficulty.climeetDifficultyName ?? "")
                                .font(Font.climeetFontParagraph4())
                                .foregroundColor(
                                    Color(hex: difficulty.gymDifficultyColor ?? "")
                                )
                        })
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                        .background(Color.text06_5)
                        .overlay(
                            Circle().stroke(
                                store.selectedDifficulty == difficulty ? Color.climeetMain
                                : .clear, lineWidth: 2
                            )
                        )
                        .clipShape(Circle())
                    }
                }
            }
        }
        .scrollIndicators(.never)
    }
    
    private var filteredRoutesScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(store.filteredRoutesResponse) { filteredRoute in
                    Button(action: {
                        store.send(.filteredRouteChangeButtonTapped(filteredRoute))
                    }, label: {
                        GeometryReader { geometry in
                            VStack(spacing: 0) {
                                if let routeImageUrl = filteredRoute.routeImageUrl,
                                   let climeetDifficultyName = filteredRoute.climeetDifficultyName,
                                   let gymDifficultyColor = filteredRoute.gymDifficultyColor {
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
                        }
                    })
                    .frame(width: 52, height: 66)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                store.selectedFilteredRoute == filteredRoute ? Color.climeetMain
                                : Color.levelBlack, lineWidth: 2
                            )
                    )
                    .padding([.leading, .top, .trailing], 1.5)
                }
            }
        }
        .scrollIndicators(.never)
    }
}
