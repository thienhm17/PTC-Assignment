//
//  EndpointType.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/15/22.
//

import Foundation

enum EndpointType {
    case getActivity(activityType: String)
    
    var request: EndpointRequest {
        switch self {
        
        case .getActivity(let activityType):
            return EndpointRequest(method: "get",
                                   path: "activity",
                                   queries: ["type" : activityType])
            
        }
    }
}

struct EndpointRequest {
    
    let method: String
    let baseUrl: String
    let path: String
    var headers: [String: String]?
    var queries: [String: Any]?
    var body: Any?
    
    init(method: String, baseUrl: String = App.Configuration.baseUrl, path: String, headers: [String: String]? = nil, queries: [String: Any]? = nil, body: Any? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.queries = queries
        self.body = body
    }
    
    func asURLRequest() -> URLRequest? {
        // build URL
        guard let urlRequest = URL(string: baseUrl + path) else { return nil }
        var request = URLRequest(url: urlRequest)
        
        // set method
        request.httpMethod = method
        // build headers
        if let headers = self.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // build queries
        if let queries = self.queries {
            let queryParams = queries.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: urlRequest.absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
        }
        // build body
        if let body = self.body as? Encodable {
            request.httpBody = body.data
        
        } else if let body = self.body as? [String: Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}
