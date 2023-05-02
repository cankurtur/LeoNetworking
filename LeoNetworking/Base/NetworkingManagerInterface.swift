//
//  NetworkingManagerInterface.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

public protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        endpoint: some Endpoint,
        responseType: T.Type,
        completion: @escaping NetworkHandler<T>
    )
    
    func request<T: Decodable>(
        endpoint: some Endpoint,
        responseType: T.Type
    ) async throws -> T
}
