//
//  rxswift_loginTests.swift
//  rxswift-loginTests
//
//  Created by 王崇磊 on 2017/10/19.
//  Copyright © 2017年 王崇磊. All rights reserved.
//

import XCTest
@testable import rxswift_login

class rxswift_loginTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUsernameVaild() {
        // 用来进行一步测试的
        let testExpectation = self.expectation(description: "UsernameVaild")
        let viewModel = NormalLoginViewModel()
        // 测试数据
        let usernames = ["123", "1234", "12345", "123456", "dingding"]
        // 预期结果
        let expecteds = [false, false, false, true, true]
        var results   = [Bool]()
        var index     = 0
        viewModel.usernameVaild = {(vaildType) in
            switch vaildType {
            case .error(_):
                results.append(false)
            case .isVaild:
                results.append(true)
            }
            index += 1
            if index == usernames.count {
                XCTAssertEqual(expecteds, results)
                testExpectation.fulfill()
            }
        }
        
        for username in usernames {
            viewModel.username = username
        }
        self.wait(for: [testExpectation], timeout: 10)
    }
}
