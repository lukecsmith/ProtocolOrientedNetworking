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
    
    static let baseURLString = "https://dev.tickets.dubaid.co.uk/api/"
    
    case loginUser
    case getUserInfo
    /*
    case get(Int)
    case create([String: Any])
    case delete(Int)
    */
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .loginUser:
                return .post
            case .getUserInfo:
                return .get
            
            //case .create:
            //    return .post
            //case .delete:
            //    return .delete
            }
        }
        let params: ([String: Any]?) = {
            switch self {
            case .loginUser:
                return nil
            case .getUserInfo:
                return nil
            }
        }()
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .loginUser:
                relativePath = "user"
            case .getUserInfo:
                relativePath = "oauth/token"
            /*
            case .get(let number):
                relativePath = "path/\(number)"
            case .create:
                relativePath = "path"
            case .delete(let number):
                relativePath = "path/\(number)"
            */
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
