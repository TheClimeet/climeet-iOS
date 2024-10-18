//
//  EvaluationClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/8/24.
//

import NetworkKit
import Dependencies

struct EvaluationClient {
    /// 클밋 운영진에게 전달하는 평가 및 리뷰
    var evaluation: @Sendable (_ content: String, _ rating: Int) async throws -> String
}

extension EvaluationClient: DependencyKey {
    static var liveValue: EvaluationClient = .init(
        evaluation: { content, rating in
            let endPoint = EvaluationEndPoint.evaluation(content: content, rating: rating)
            return try await APIClient.shared.request(endPoint, decode: String.self)
        }
    )
}

extension DependencyValues {
    var evaluationClient: EvaluationClient {
        get { self[EvaluationClient.self] }
        set { self[EvaluationClient.self] = newValue }
    }
}
