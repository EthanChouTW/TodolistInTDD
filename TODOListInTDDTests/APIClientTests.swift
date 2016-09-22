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

        let completion = { (error: ErrorType?) in }

        // 這裡的username 跟password有奇怪符號 ，string轉成NSURL會fail
        sut.loginUserWithName("dasdöm",
                              password: "%&34",
                              completion: completion)
        XCTAssertNotNil(mockURLSession.completionHandler)
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = NSURLComponents(URL: url,
                                            resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
           XCTAssertEqual(urlComponents?.path, "/login")

       // 改成編碼，避免url後面的param會因為使用者帳號密碼有&%#@符號而出現傳錯param的問題
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        guard let expectedUsername = "dasdöm".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        else {
            fatalError()
        }
        guard let expectedPassword = "%&34".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        else {
            fatalError()
        }
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
                       "username=\(expectedUsername)&password=\(expectedPassword)")
    }

    func testLogin_CallsResumeOfDataTask() {
        
        let completion = { (error: ErrorType?) in }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }

    func testLogin_SetsToken() {
        let mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        let completion = { (error: ErrorType?) in }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        let responseDict = ["token" : "1234567890"]
        let responseData = try! NSJSONSerialization.dataWithJSONObject(responseDict, options: [])
        mockURLSession.completionHandler?(responseData, nil, nil)
        let token = mockKeychainManager.passwordForAccount("token")
        XCTAssertEqual(token, responseDict["token"])
    }

    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        var theError: ErrorType?
        let completion = { (error: ErrorType?) in
            theError = error
        }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        //丟一個空的data進去拿到token, theError的error不會是nil了
        let responseData = NSData()
        mockURLSession.completionHandler?(responseData, nil, nil)
        XCTAssertNotNil(theError)
    }

    func testLogin_ThrowsErrorWhenDataIsNil() {
        var theError: ErrorType?
        let completion = { (error: ErrorType?) in
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
        var theError: ErrorType?
        let completion = { (error: ErrorType?) in
            theError = error
        }
        sut.loginUserWithName("dasdom",
                              password: "1234",
                              completion: completion)
        let responseDict = ["token" : "1234567890"]
        let responseData = try! NSJSONSerialization.dataWithJSONObject(responseDict,
            options: [])
        let error = NSError(domain: "SomeError", code:
            1234, userInfo: nil)
        mockURLSession.completionHandler?(responseData, nil, error)
        XCTAssertNotNil(theError)
    }

}


extension APIClientTests {
    class MockURLSession :ToDoURLSession {
        typealias Handler = (NSData!, NSURLResponse!, NSError!)
            -> Void
        var completionHandler: Handler?
        var url: NSURL?
        var dataTask = MockURLSessionDataTask()
         func dataTaskWithURL(url: NSURL,
                             completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask

        }
    }

    // 用resume處理上面session吐出來的NSURLSessionDataTask
    class MockURLSessionDataTask : NSURLSessionDataTask {
        var resumeGotCalled = false
        override func resume() {
            resumeGotCalled = true
        }
    }

    class MockKeychainManager : KeychainAccessible {
        var passwordDict = [String:String]()
        func setPassword(password: String,
                         account: String) {
            passwordDict[account] = password
        }
        func deletePasswortForAccount(account: String) {
            passwordDict.removeValueForKey(account)
        }
        func passwordForAccount(account: String) -> String? {
            return passwordDict[account]
        }
    }



}
