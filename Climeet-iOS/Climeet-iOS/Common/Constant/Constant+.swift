//
//  Constant+.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import Foundation

enum SocialType: String, Codable {
    case kakao = "KAKAO"
    case naver = "NAVER"
    case apple = "APPLE"
}

enum ClimbingLevel: String, Codable {
    case BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, EXPERT
}

enum DiscoveryChannel: String, Codable {
    case INSTAGRAM_FACEBOOK, YOUTUBE, FRIEND_RECOMMENDATION, BLOG_CAFE_COMMUNITY, OTHER
}

enum SignResponseType: String, Codable {
    case SIGN_IN, SIGN_UP
}

enum ServiceBitmask: String, Codable {
    case shower_facilities = "샤워_시설"
    case shower_goods = "샤워_용품"
    case towels_provided = "수건_제공"
    case simple_sleeping_stand = "간이_세면대"
    case choke_rent = "초크_대여"
    case rock_wall_painting_rent = "암벽화_대여"
    case tripod_rent = "삼각대_대여"
    case sportswear_rent = "운동복_대여"
}

enum SortType: String, Codable {
    case LATEST
    case POPULAR
}

enum ShortsVisibility: String, Codable {
    case PUBLIC
    case FOLLOWERS_ONLY
    case PRIVATE
}

enum ShortsState: String, Codable {
    case LIKE
    case DISLIKE
    case NONE
}
