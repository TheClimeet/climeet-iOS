//
//  CustomTabView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/16/24.
//

import SwiftUI
import DesignSystem

struct CustomTabView: View {
    @Binding var selectedTab: MainTab
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    Button {
                        selectedTab = .home
                    } label: {
                        VStack {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(
                                    selectedTab == .home ? .climeetMain : .levelBlack
                                )
                            
                            Image(uiImage: UIImage(named: selectedTab == .home ? "content_home" : "content_home_notselect") ?? UIImage())
                            Text("홈")
                                .font(.climeetFontCaptionText3())
                                .foregroundColor(
                                    selectedTab == .home ? .levelWhite : .text05
                                )
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        selectedTab = .shorts
                    } label: {
                        VStack {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(
                                    selectedTab == .shorts ? .climeetMain : .levelBlack
                                )
                            
                            Image(
                                uiImage: UIImage(named: selectedTab == .shorts ? "content_shorts" : "content_shorts_notselect") ?? UIImage())
                            Text("Shorts")
                                .font(.climeetFontCaptionText3())
                                .foregroundColor(
                                    selectedTab == .shorts ? .levelWhite : .text05
                                )
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        selectedTab = .upload
                    } label: {
                        VStack {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(
                                    selectedTab == .upload ? .climeetMain : .levelBlack
                                )
                            
                            Image(uiImage: UIImage(named: "content_upload_notselect") ?? UIImage())
                            Text("업로드")
                                .font(.climeetFontCaptionText3())
                                .foregroundColor(
                                    selectedTab == .upload ? .levelWhite : .text05
                                )
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        selectedTab = .activity
                    } label: {
                        VStack {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(
                                    selectedTab == .activity ? .climeetMain : .levelBlack
                                )
                            
                            Image(uiImage: UIImage(named: selectedTab == .activity ? "content_activity" : "content_activity_notselect") ?? UIImage())
                            Text("운동기록")
                                .font(.climeetFontCaptionText3())
                                .foregroundColor(
                                    selectedTab == .activity ? .levelWhite : .text05
                                )
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        selectedTab = .mypage
                    } label: {
                        VStack {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(
                                    selectedTab == .mypage ? .climeetMain : .levelBlack
                                )
                            
                            Image(uiImage: UIImage(named: selectedTab == .mypage ? "content_mypage" : "content_mypage_notselect") ?? UIImage())
                            Text("마이페이지")
                                .font(.climeetFontCaptionText3())
                                .foregroundColor(
                                    selectedTab == .mypage ? .levelWhite : .text05
                                )
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                }
            }
        }
    }
}
