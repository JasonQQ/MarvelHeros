import Foundation

public struct Event: Decodable {
    public let id: Int
    public let title: String?
    public let description: String?
}
