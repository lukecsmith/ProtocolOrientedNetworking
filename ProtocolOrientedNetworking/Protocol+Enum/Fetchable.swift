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
 Fetchable is a protocol that allows any (data model) object to become one that can fetch contents from a web server, by calling the function defined below on itself, fetch(), with the given parameters.  If the call is succesful the model object becomes populated with the results from the service.  Alamofire is used for the calls, and Unbox is used to decode the JSON.
 */
protocol Fetchable {}

/*
 Using a protocol extension allows us to fully define the fetch function here, rather than requiring each conforming object to define it.
 */
extension Fetchable where Self: Unboxable {
    
    static func fetch(with request: URLRequestConvertible, onSuccess: @escaping SuccessHandler<Self>, onError: @escaping ErrorHandler) {
        
        Alamofire.request(request).responseJSON { response in
            if let errorData = response.result.error {
                //server returned an error.  return that error
                onError(errorData)
                return
            }
            if let data = response.data {
                //server received some data
                do {
                    //if data received is of type Self (ie whatever type called this fetch) - create an object of that type and return it.
                    let mapped: Self = try unbox(data: data)
                    //creating self type object worked, so pass it back via success completion closure
                    onSuccess(.asSelf(mapped))
                } catch {
                    do {
                        //try to create a Dictionary from the downloaded data
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]]
                        var mappedDictionary = [String: Self]()
                        try json?.forEach { key, value in
                            let data: Self = try unbox(dictionary: value)
                            mappedDictionary[key] = data
                        }
                        //creating dictionary worked, so pass it back via success completion closure
                        onSuccess(.asDictionary(mappedDictionary))
                    } catch {
                        do {
                            //try to create an Array from the downloaded data
                            let mapped: [Self] = try unbox(data: data)
                            //creating array worked, so pass it back via success completion closure
                            onSuccess(.asArray(mapped))
                        } catch {
                            //all that failed, so return the raw data
                            onSuccess(.raw(data))
                        }
                    }
                }
            }
        }
    }
}
