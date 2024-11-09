//
//  Collection + subscript.swift
//  Climeet-iOS
//
//  Created by 권승용 on 11/10/24.
//

extension Collection {
    
    ///  안전하게 index 접근하기 위한 subscript 제공
    subscript (safe index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
