//
//  Typealias.swift
//  LeoNetworking
//
//  Created by Can Kurtur on 29.04.2023.
//

import Foundation

public typealias Closure<T> = ( (T) -> Void )
public typealias NetworkHandler<T> = (Result<T, APIClientError>) -> Void where T: Decodable
public typealias ErrorStatusCodeHandler = Closure<Int>
