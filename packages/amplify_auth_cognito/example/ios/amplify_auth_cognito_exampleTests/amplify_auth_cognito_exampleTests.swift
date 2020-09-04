//
//  amplify_auth_cognito_exampleTests.swift
//  amplify_auth_cognito_exampleTests
//
//  Created by Noyes, Dustin on 9/4/20.
//

import XCTest
import amplify_auth_cognito

class amplify_auth_cognito_exampleTests: XCTestCase {

    var plugin: SwiftAuthCognito?;

    override func setUpWithError() throws {
        plugin = SwiftAuthCognito();
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let call = FlutterMethodCall( methodName: "signUp", arguments: nil )
        plugin!.handle( call, result: {(result)->Void in
            if let strResult = result as? String {
                XCTAssertEqual( "iOS 12.4", strResult )
            }
        })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
