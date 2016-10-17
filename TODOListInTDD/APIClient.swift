//
//  APIClient.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/20.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?
    func loginUserWithName(_ username: String,
                           password: String,
                           completion: (@escaping (Error?) -> Void)) {
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            else {
                fatalError()
        }
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            else {
                fatalError()
        }
        guard let url = URL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else
        { fatalError() }
        let task = session.dataTask(with: url) { (data, response, error) in

            if error != nil {
                completion(WebserviceError.responseError)
                return
            }

            if let theData = data {
                do {
                    let responseDict = try JSONSerialization.jsonObject(with: theData, options: []) as! [String:AnyObject]
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(token,
                                                      account: "token")
                } catch {
                    completion(error)
                }
            }  else {
                // if data == nil
                completion(WebserviceError.dataEmptyError)
            }
        }
        task.resume()

    }

}

enum WebserviceError : Error {
    case dataEmptyError
    case responseError
}

protocol ToDoURLSession {

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession : ToDoURLSession {

 }
