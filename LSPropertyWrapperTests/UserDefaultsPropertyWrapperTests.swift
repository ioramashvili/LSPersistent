import XCTest
import LSPropertyWrapper
import LSPersistentKit

class UserDefaultsPropertyWrapperTests: XCTestCase {
    override func setUp() {
        clearUserDefaults()
    }
    
    private func clearUserDefaults() {
        guard let identifier = Bundle.main.bundleIdentifier else {return}
        
        UserDefaults.standard.removePersistentDomain(forName: identifier)
    }
    
    func testSessionId() {
        XCTAssertNil(UserSession.sessionId)
        
        let sessionId = "SessionId"
        UserSession.sessionId = sessionId
        XCTAssertEqual(UserSession.sessionId, sessionId)

        UserSession.sessionId = nil
        XCTAssertEqual(UserSession.sessionId, nil)
        XCTAssertNil(UserSession.sessionId)
    }
    
    func testIsLoggedIn() {
        XCTAssertFalse(UserSession.isLoggedIn)
        
        UserSession.isLoggedIn = true
        XCTAssertTrue(UserSession.isLoggedIn)
    }
    
    func testData() {
        XCTAssertNil(UserSession.token)

        let string = "String"
        let token = string.data(using: .utf8)
        UserSession.token = token
        XCTAssertNotNil(UserSession.token)
        XCTAssertEqual(UserSession.token, token)

        UserSession.token = nil
        XCTAssertNil(UserSession.token)
    }
    
    func testCodable() {
        XCTAssertNil(UserSession.fullName)
        
        let fullName = UserSession.FullName(firstName: "FirstName", lastName: "LastName")
        UserSession.fullName = fullName
        XCTAssertEqual(UserSession.fullName, fullName)
        
        UserSession.fullName = nil
        XCTAssertNil(UserSession.fullName)
    }
}

fileprivate struct UserSession {
    @LSUserDefault("sessionId", defaultValue: nil)
    static var sessionId: String?
    
    @LSUserDefault(.standard, key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
    
    @LSUserDefault("token", defaultValue: nil)
    static var token: Data?
    
    @LSCodableUserDefault(.standard, key: "fullName", defaultValue: nil)
    static var fullName: FullName?
    
    struct FullName: Codable, Equatable {
        public let firstName: String
        public let lastName: String
    }
}
