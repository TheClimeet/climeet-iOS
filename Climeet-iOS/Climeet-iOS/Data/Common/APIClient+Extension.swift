//
//  APIClient+Extension.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/18/24.
//

import Foundation
import Alamofire
import NetworkKit

extension APIClient {
    static let shared: APIClient = APIClient(session: .default, tokenRefresher: TokenRefresher())
}
