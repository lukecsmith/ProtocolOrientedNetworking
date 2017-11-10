//
//  RouterEnum.swift
//  DubAidAdmin
//
//  Created by Luke Smith on 01/11/2017.
//  Copyright © 2017 LukeSmith. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://yourwebserverURL.com/api/etc/"
    
    case generalPost([String: Any])
    case getUserData(Int)
    case deleteSomething(Int)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .generalPost:
                return .post
            case .getUserData:
                return .get
            case .deleteSomething:
                return .delete
            }
        }
        let params: ([String: Any]?) = {
            switch self {
            case .generalPost(let dict):
                return dict
            case .getUserData, .deleteSomething:
                return nil
            }
        }()
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .generalPost:
                relativePath = "generalPostPath"
            case .getUserData(let pathNumber):
                relativePath = "getUserDataPath/\(pathNumber)"
            case .deleteSomething(let pathNumber):
                relativePath = "deleteSomethingPath/\(pathNumber)"
            }
            
            var url = URL(string: Router.baseURLString)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            print("Returning URL: \(url.description)")
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: params)
    }
}
