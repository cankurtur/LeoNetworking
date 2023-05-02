//
//  EncodableExtension.swift
//  LeoNetworkingTests
//
//  Created by Can Kurtur on 2.05.2023.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return nil
        }
        return dictionary
    }
}
