//
//  APIService.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/15/22.
//

import Foundation
import Combine

typealias CompletionHandler<T: Decodable> = ((Result<T, APIError>) -> Void)

class APIService {
    
    static func execute<T>(endpoint: EndpointType,
                           decodingType: T.Type,
                           queue: DispatchQueue = .main,
                           retries: Int = 0) -> AnyPublisher<T, APIError> where T: Decodable {
        
        return endpoint.request.asURLRequest().publisher
            .flatMap { URLSession.shared.dataTaskPublisher(for: $0) }
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else {
                    throw APIError.unknow
                }
                guard response.statusCode < 300 else {
                    throw APIError.specifiedCode(response.statusCode)
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { APIError.map($0) }
            .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case specifiedCode(Int)
    case other(Error)
    case unknow
    
    var errorMessage: String {
        switch self {
        case .specifiedCode(let code):
            return "Error code: \(code)"
        case .other(let error):
            return error.localizedDescription
        case .unknow:
            return "Unexpected Error, Please try again!"
        }
    }
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(error)
    }
}
