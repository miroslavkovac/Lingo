import Foundation

/// Since it is not possible to include any resources with SPM, this class will generate them.
/// In Swift4 we can use multiline string literals for JSON file fixtures.
class DefaultFixtures {
    
    public static func setup(atPath path: String) throws {
        try FileManager().createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        
        try self.enLocalizations.write(toFile: path + "/en.json", atomically: true, encoding: .utf8)
        try self.enLocalizations.write(toFile: path + "/en-XX.json", atomically: true, encoding: .utf8)
        try self.deLocalizations.write(toFile: path + "/de.json", atomically: true, encoding: .utf8)
    }
    
    private static var enLocalizations: String {
        return
"{" +
    "\"hello.world\": \"Hello World!\"," +
    "\"unread.messages\": {" +
        "\"one\": \"You have an unread message.\"," +
        "\"other\": \"You have %{unread-messages-count} unread messages.\"" +
    "}" +
"}"
    }
    
    private static var deLocalizations: String {
        return
"{" +
    "\"hello.world\": \"Hallo Welt!\"," +
    "\"unread.messages\": {" +
        "\"one\": \"Du hast eine ungelesene Nachricht.\"," +
        "\"other\": \"Du hast %{unread-messages-count} ungelesene Nachrichten.\"" +
    "}" +
"}"
    }

}
