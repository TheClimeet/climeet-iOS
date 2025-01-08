//
//  File.swift
//  DesignSystem
//
//  Created by 송형욱 on 1/7/25.
//

import Foundation
import UIKit

extension UIApplication {
    public func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
