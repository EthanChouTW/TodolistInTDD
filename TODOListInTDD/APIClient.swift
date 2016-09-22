//
//  APIClient.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/20.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: ToDoURLSession = NSURLSession.sharedSession()
    var keychainManager: KeychainAccessible?
    func loginUserWithName(username: String,
                           password: String,
                           completion: (ErrorType?) -> Void) {
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        guard let encodedUsername = username.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
            else {
                fatalError()
        }
        guard let encodedPassword = password.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
            else {
                fatalError()
        }
        guard let url = NSURL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else
        { fatalError() }
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in

            if error != nil {
                completion(WebserviceError.ResponseError)
                return
            }

            if let theData = data {
                do {
                    let responseDict = try NSJSONSerialization.JSONObjectWithData(theData, options: [])
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(token,
                                                      account: "token")
                } catch {
                    completion(error)
                }
            }  else {
                // if data == nil
                completion(WebserviceError.DataEmptyError)
            }
        }
        task.resume()

    }

}

enum WebserviceError : ErrorType {
    case DataEmptyError
    case ResponseError
}

protocol ToDoURLSession {
    func dataTaskWithURL(url: NSURL,
                         completionHandler: (NSData?, NSURLResponse?, NSError?) ->
        Void) -> NSURLSessionDataTask
}

extension NSURLSession : ToDoURLSession { }