//
//  BannerView.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct BannerView: View {
    @Bindable var store: StoreOf<BannerReducer>
    
    let screenWidth = UIWindow().screen.bounds.width
    
    var body: some View {
        BidirectionalInfiniteBanner(
            currentIndex: $store.selection,
            bannerCount: store.bannerInfos.count,
            prevURL: {
                guard !store.bannerInfos.isEmpty else {
                    return nil
                }
                
                var prevIndex = store.selection - 1
                if prevIndex == -1 {
                    prevIndex = store.bannerInfos.count - 1
                }
                return URL(string: store.bannerInfos[prevIndex].bannerImageURL)
            },
            currentURL: {
                guard !store.bannerInfos.isEmpty else {
                    return nil
                }
                
                return URL(string: store.bannerInfos[store.selection].bannerImageURL)
            },
            nextURL: {
                guard !store.bannerInfos.isEmpty else {
                    return nil
                }
                
                var nextIndex = store.selection + 1
                if nextIndex == store.bannerInfos.count {
                    return URL(string: store.bannerInfos[0].bannerImageURL)
                } else {
                    return URL(string: store.bannerInfos[nextIndex].bannerImageURL)
                }
            }
        )
        .frame(width: screenWidth, height: screenWidth / 2.08)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(String(format: "%02d / %02d", store.selection + 1, store.bannerInfos.count))                        .font(.climeetFontCaptionText1())
                        .foregroundStyle(.white)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.text09.opacity(0.4))
                        }
                        .padding(.trailing, 11)
                        .padding(.bottom, 11)
                }
            }
        }
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    let store = StoreOf<BannerReducer>(initialState: BannerReducer.State()) {
        BannerReducer()
    }
    BannerView(store: store)
}

struct BidirectionalInfiniteBanner: View {
    
    @Binding var currentIndex: Int
    @State private var selection: Int = 0
    
    let screenWidth = UIWindow().screen.bounds.width
    let bannerCount: Int
    
    var prevURL: () -> URL?
    var currentURL: () -> URL?
    var nextURL: () -> URL?
    
    var body: some View {
        TabView(selection: $selection) {
            KFImage(prevURL())
                .scaledToFill()
                .frame(width: screenWidth, height: screenWidth / 2.08)
                .clipped()
                .tag(-1)
            
            KFImage(currentURL())
                .scaledToFill()
                .frame(width: screenWidth, height: screenWidth / 2.08)
                .clipped()
                .tag(0)
                .onDisappear {
                    switch selection {
                    case -1:
                        if currentIndex - 1 == -1 {
                            currentIndex = bannerCount - 1
                        } else {
                            currentIndex -= 1
                        }
                    case 0:
                        break
                    case 1:
                        if currentIndex + 1 == bannerCount {
                            currentIndex = 0
                        } else {
                            currentIndex += 1
                        }
                    default:
                        break
                    }
                    selection = 0
                }
            
            KFImage(nextURL())
                .scaledToFill()
                .frame(width: screenWidth, height: screenWidth / 2.08)
                .clipped()
                .tag(1)
        }
        .disabled(selection != 0)
    }
}
