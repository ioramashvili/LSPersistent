import LSPersistentKit

public class KeychainContainer {
    public static let defaultKeychainGroup = "BJ8RU8C34V.com.leavingstone.LSPropertyWrapper"
    public static let shared = KeychainWrapper(serviceName: defaultKeychainGroup, accessGroup: nil)
}

