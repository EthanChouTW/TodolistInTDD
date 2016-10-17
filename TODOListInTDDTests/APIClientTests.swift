//
//  APIClientTests.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/20.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD


class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    
    override func setUp() {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLogin_MakesRequestWithUsernameAndPassword() {

        let completion = { (error: Error?) in }

        // 這裡的username 跟password有奇怪符號 ，string轉成NSURL會fail
        sut.loginUserWithName("dasdöm",
                              password: "%&34",
                              completion: completion)
        XCTAssertNotNil(mockURLSession.completionHandler)
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url,
                                            resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
           XCTAssertEqual(urlComponents?.path, "/login")

       // 改成編碼，避免url後面的param會因為使用者帳號密碼有&%#@符號而出現傳錯param的問題
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let expectedUsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {
            fatalError()
        }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {
            fatalError()
        }
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
                       "username=\(expectedUsername)&password=\(expectedPassword)")
    }

    func testLogin_CallsResumeOfDataTask() {
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }

    func testLogin_SetsToken() {
        let mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        let responseDict = ["token" : "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        mockURLSession.completionHandler?(responseData, nil, nil)
        let token = mockKeychainManager.passwordForAccount("token")
        XCTAssertEqual(token, responseDict["token"])
    }

    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        //丟一個空的data進去拿到token, theError的error不會是nil了
        let responseData = Data()
        mockURLSession.completionHandler?(responseData, nil, nil)
        XCTAssertNotNil(theError)
    }

    func testLogin_ThrowsErrorWhenDataIsNil() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        mockURLSession.completionHandler?(nil, nil, nil)
        XCTAssertNotNil(theError)
    }

    // 處理server回傳的error
    func testLogin_ThrowsErrorWhenResponseHasError() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        let responseDict = ["token" : "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict,
            options: [])
        let error = NSError(domain: "SomeError", code:
            1234, userInfo: nil)
        mockURLSession.completionHandler?(responseData, nil, error)
        XCTAssertNotNil(theError)
    }

}


extension APIClientTests {
    class MockURLSession :ToDoURLSession {
        typealias Handler = (Data?, URLResponse?, NSError?)
            -> Void
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }

    // 用resume處理上面session吐出來的NSURLSessionDataTask
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        override func resume() {
            resumeGotCalled = true
        }
    }

    class MockKeychainManager : KeychainAccessible {
        var passwordDict = [String:String]()
        func setPassword(_ password: String,
                         account: String) {
            passwordDict[account] = password
        }
        func deletePasswortForAccount(_ account: String) {
            passwordDict.removeValue(forKey: account)
        }
        func passwordForAccount(_ account: String) -> String? {
            return passwordDict[account]
        }
    }



}
