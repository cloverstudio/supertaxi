//
//  Tools.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 13/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation

open class Tools {
    
    func sha1(_ string: String) -> String {
        let data = string.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        
        return hexBytes.joined(separator: "")
    }
    
    func getErrorFromCode(_ code: NSInteger) -> String {
        
        if (code == 6000000) {
            return "UnknownError"
        } else if (code == 6000001){
            return "You must enter your email."
        } else if (code == 6000002){
            return "You must enter your password."
        } else if (code == 6000004){
            return "You must enter valid email address."
        } else if (code == 6000005){
            return "You must enter valid password."
        } else if (code == 6000006){
            return "Email already exists."
        } else if (code == 6000010){
            return "You must enter your name."
        } else if (code == 6000013){
            return "You must enter start fee."
        } else if (code == 6000014){
            return "You must enter km fee."
        } else if (code == 6000015){
            return "You must enter your age"
        } else if (code == 6000016){
            return "You must enter your telephone number"
        } else if (code == 6000001){
            return "You must enter your email"
        } else if (code == 6000008){
            return "You must enter valid email address."
        }
        
        return "Unknown error. Please try again."
    }
}


