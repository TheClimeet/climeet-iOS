//
//  SearchView.swift
//  Climeet-iOS
//
//  Created by KOVI on 5/23/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture
import DesignSystem

struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            if store.state.transitionType == .modal {
                VStack(alignment: .center, spacing: 15) {
                    Text("암장선택")
                        .foregroundColor(Color.levelWhite)
                        .font(.climeetFontTitle4())
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray72)
                }
                .frame(height: 62)
                .frame(maxWidth: .infinity)
                .background(Color.text09)
            }
            
            VStack {
                HStack {
                    if store.state.transitionType == .push {
                        Button(action: {
                            store.send(.backButtonTapped)
                        }) {
                            Image(uiImage: UIImage(named: "search_back") ?? UIImage())
                        }
                        .frame(width: 18, height: 16)
                        .padding([.leading], 15)
                        .padding([.trailing], 19)
                    }
                    
                    TextField(
                        "",
                        text: $store.keyword.sending(\.keywordChanged),
                        prompt: Text("암장검색하기")
                            .foregroundColor(Color.levelGray)
                    )
                    .accentColor(.climeetMain)
                    .foregroundColor(.white)
                    .font(.climeetFontParagraph2())
                    .padding([.leading], 30) // 텍스트필드 글자의 패딩
                    .frame(maxWidth: .infinity, minHeight: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.text08)
                    )
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                        }
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 15)
                
                if store.state.isEmptySearchResult {
                    VStack {
                        Image(uiImage: UIImage(named: "list_empty") ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipped()
                        
                        Text("검색 결과가 없어요.\n다른 검색어로 검색해 보세요!")
                            .font(.climeetFontParagraph2())
                            .foregroundColor(.text06)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.top, 92)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if !store.state.isHomeGymsVisible {
                            Section {
                                Text("홈짐")
                                    .foregroundColor(Color.levelWhite)
                                    .font(.climeetFontParagraph1())
                                    .listRowBackground(Color.clear)
                                
                                ForEach(store.homeGyms) { gym in
                                    HStack {
                                        KFImage(URL(string: gym.profileImageUrl))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 35, height: 35)
                                            .clipped()
                                            .cornerRadius(17.5)
                                        Text(gym.name)
                                            .font(Font.climeetFontParagraph2())
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        Button("선택하기") {
                                            store.send(.selectButtonTapped(gym))
                                        }
                                        .frame(width: 77, height: 24, alignment: .center)
                                        .font(.climeetFontCaptionText3())
                                        .foregroundColor(Color.levelBlack)
                                        .background(Color.climeetMain)
                                        .cornerRadius(8)
                                    }
                                    .listRowInsets(EdgeInsets(top: 25, leading: 22, bottom: 25, trailing: 22))
                                    .listRowBackground(Color.clear)
                                }
                            }
                            
                        }
                        
                        if let searchResult = store.searchResult {
                            ForEach(searchResult.gyms) { gym in
                                HStack {
                                    KFImage(URL(string: gym.profileImageUrl))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 35)
                                        .clipped()
                                        .cornerRadius(17.5)
                                    
                                    Text(gym.name) { string in
                                        string.foregroundColor = .white
                                        string.font = .climeetFontParagraph2()
                                        if let range = string.range(of: store.state.keyword) {
                                            string[range].foregroundColor = .climeetMain
                                        }
                                    }
                                    Spacer()
                                    Button("선택하기") {
                                        store.send(.selectButtonTapped(gym))
                                    }
                                    .frame(width: 77, height: 24, alignment: .center)
                                    .font(.climeetFontCaptionText3())
                                    .foregroundColor(Color.levelBlack)
                                    .background(Color.climeetMain)
                                    .cornerRadius(8)
                                }
                                .listRowInsets(EdgeInsets(top: 25, leading: 22, bottom: 25, trailing: 22))
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                    .background(.clear)
                    .listStyle(.plain)
                    .onAppear {
                        store.send(.onAppear)
                    }
                }
            }
            .background(Color.text09)
            .toolbar(.hidden, for: .automatic)
        }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
        SearchReducer()
    }))
}
