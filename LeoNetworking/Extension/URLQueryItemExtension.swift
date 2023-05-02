//
//  URLQueryItemExtension.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

extension URLQueryItem {
    static func queryItems(dictionary: [String: Any]) -> [URLQueryItem] {
        dictionary.map {
            URLQueryItem(name: $0, value: ($1 as? LosslessStringConvertible)?.description)
        }
    }
}
