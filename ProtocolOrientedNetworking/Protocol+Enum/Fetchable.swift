//
//  Fetchable.swift
//  DubAidAdmin
//
//  Created by Luke Smith on 12/10/2017.
//  Copyright © 2017 LukeSmith. All rights reserved.
//

import Foundation
import Unbox
import Alamofire

enum MappingResult<T> {
    case asSelf(T)
    case asDictionary([String: T])
    case asArray([T])
    case raw(Data)
}

typealias ErrorHandler = (Error) -> Void
typealias SuccessHandler<T> = (MappingResult<T>) -> Void where T: Unboxable

/*
 Fetchable is a protocol that allows a standard data model object to become one that can fetch its own contents from a web server, by calling the function defined below on itself, fetch(), with the given parameters.  If the call is succesful the model object becomes populated with the results from the service.  Alamofire is used for the calls, and Unbox is used to decode the JSON.
 */
protocol Fetchable {}

/*
 Using a protocol extension allows us to fully define the function here, rather than just specifying the function name, as happens in a traditional protocol.
 */
extension Fetchable where Self: Unboxable {
    
    static func fetch(with request: URLRequestConvertible, onSuccess: @escaping SuccessHandler<Self>, onError: @escaping ErrorHandler) {
        
        Alamofire.request(request).responseJSON { response in
            if let errorData = response.result.error {
                onError(errorData)
                return
            }
            if let data = response.data {
                do {
                    let mapped: Self = try unbox(data: data)
                    onSuccess(.asSelf(mapped))
                } catch {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]]
                        var mappedDictionary = [String: Self]()
                        try json?.forEach { key, value in
                            let data: Self = try unbox(dictionary: value)
                            mappedDictionary[key] = data
                        }
                        onSuccess(.asDictionary(mappedDictionary))
                    } catch {
                        do {
                            let mapped: [Self] = try unbox(data: data)
                            onSuccess(.asArray(mapped))
                        } catch {
                            do {
                                onSuccess(.raw(data))
                            } catch {
                                onError(error)
                            }
                        }
                    }
                }
            }
        }
    }
}
