//
//  BestClimberable.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/10/24.
//

protocol BestClimberable: Identifiable, Equatable {
    var ranking: Int { get }
    var profileImageURL: String { get }
    var profileName: String { get }
    var description: String { get }
}
