//
//  APIService.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/15/22.
//

import Foundation

typealias CompletionHandler<T: Decodable> = ((Swift.Result<T, Error>) -> Void)

class APIService {
    
    static func request<T: Decodable>(endpoint: EndpointType, completion: CompletionHandler<T>?) {
        guard let urlRequest = endpoint.request.asURLRequest() else {
            completion?(.failure(APIServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                if let response = response as? HTTPURLResponse {
                    completion?(.failure(APIServiceError.specifiedCode(code: response.statusCode)))
                } else {
                    completion?(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                completion?(.failure(APIServiceError.responseSerializationFailed))
                return
            }
            
            do {
                // return success if can decode to specified object
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion?(.success(jsonData))
            }
            catch {
                // if status 204
                if let response = response as? HTTPURLResponse,
                   response.statusCode == 204,
                   let emptyArray = [] as? T {
                    // return an empty array
                    completion?(.success(emptyArray))
                }
                else {
                    // return error decodable
                    completion?(.failure(APIServiceError.responseSerializationFailed))
                }
            }
        }.resume()
    }
}

enum APIServiceError: Error {
    case specifiedCode(code: Int)
    case responseSerializationFailed
    case invalidURL
    case unknow
    
    var errorMessage: String {
        switch self {
        case .specifiedCode(let code):
            return "Error code: \(code)"
        case .responseSerializationFailed:
            return "Serialization Failed"
        case .invalidURL:
            return "Invalid URL"
        case .unknow:
            return "Unexpected Error, Please try again!"
        }
        
    }
    
    static func getMsg(_ error: Error) -> String {
        return (error as? APIServiceError)?.errorMessage ?? error.localizedDescription
    }
}
