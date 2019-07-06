import XCTest
import LSPropertyWrapper
import LSPersistent

class KeyChainPropertyWrapperTests: XCTestCase {
    override func setUp() {
        _ = KeychainContainer.shared.removeAllKeys()
    }
    
    func testSessionId() {
        XCTAssertNil(UserSession.sessionId)
        
        let sessionId = "SessionId"
        UserSession.sessionId = sessionId
        XCTAssertTrue(UserSession.$sessionId.isSuccessfullySaved)
        XCTAssertEqual(UserSession.sessionId, sessionId)
        
        UserSession.sessionId = nil
        XCTAssertTrue(UserSession.$sessionId.isSuccessfullySaved)
        XCTAssertNil(UserSession.sessionId)
    }
    
    func testIsLoggedIn() {
        XCTAssertFalse(UserSession.isLoggedIn)
        
        UserSession.isLoggedIn = true
        XCTAssertTrue(UserSession.$isLoggedIn.isSuccessfullySaved)
        XCTAssertTrue(UserSession.isLoggedIn)
    }
    
    func testData() {
        XCTAssertNil(UserSession.token)
        
        let string = "String"
        let token = string.data(using: .utf8)
        UserSession.token = token
        XCTAssertTrue(UserSession.$token.isSuccessfullySaved)
        XCTAssertNotNil(UserSession.token)
        XCTAssertEqual(UserSession.token, token)
        
        UserSession.token = nil
        XCTAssertTrue(UserSession.$token.isSuccessfullySaved)
        XCTAssertNil(UserSession.token)
    }
    
    func testCodable() {
        XCTAssertNil(UserSession.fullName)
        
        let fullName = UserSession.FullName(firstName: "FirstName", lastName: "LastName")
        UserSession.fullName = fullName
        XCTAssertTrue(UserSession.$fullName.isSuccessfullySaved)
        XCTAssertEqual(UserSession.fullName, fullName)
        
        UserSession.fullName = nil
        XCTAssertTrue(UserSession.$fullName.isSuccessfullySaved)
        XCTAssertNil(UserSession.fullName)
    }
}

fileprivate struct UserSession {
    @LSRegularKeychain(KeychainContainer.shared, key: "sessionId", defaultValue: nil)
    static var sessionId: String?
    
    @LSRegularKeychain(KeychainContainer.shared, key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
    
    @LSRegularKeychain(KeychainContainer.shared, key: "token", defaultValue: nil)
    static var token: Data?
    
    @LSCodableKeychain(KeychainContainer.shared, key: "fullName", defaultValue: nil)
    static var fullName: FullName?
    
    struct FullName: Codable, Equatable {
        public let firstName: String
        public let lastName: String
    }
}
