//
//  UserData.swift
//  DubAidAdmin
//
//  Created by Luke Smith on 09/10/2017.
//  Copyright © 2017 LukeSmith. All rights reserved.
//

import Foundation
import Unbox

/*
 Conforming this object to the Fetchable protocol allows the object to do the 'fetch' call specified in that protocol.  We then conform to Unboxable to allow the results of that call to be parsed and converted into objects of this type.  Printable simply allows us to log out the contents.
 */
struct UserData : Fetchable, Unboxable, Printable {
    
    var user_name : String
    var user_phone : String
    var user_address1 : String
    var user_address2 : String
    
    init(unboxer: Unboxer) throws {
        user_name = try unboxer.unbox(key: "user_name")
        user_phone = try unboxer.unbox(key: "user_phone")
        user_address1 = try unboxer.unbox(key: "user_address1")
        user_address2 = try unboxer.unbox(key: "user_address2")
    }
    
    func printContents() {
        print("User Name : \(user_name)")
        print("User Phone : \(user_phone)")
        print("User Address 1 : \(user_address1)")
        print("User Address 2 : \(user_address2)")
    }
}
