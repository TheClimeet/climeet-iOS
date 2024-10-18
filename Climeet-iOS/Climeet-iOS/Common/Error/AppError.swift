//
//  AppError.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/1/24.
//

import Foundation

enum AppError: Error, Equatable {
    case networkError(String)
    case urlConvertingError(String)
    case unknownError(String)
    case imageConvertingError(String)
    case dataParsingError(String)
}

/*
case parsingError(String)
case localDataFetchError(String)
case serverError(String)
*/
