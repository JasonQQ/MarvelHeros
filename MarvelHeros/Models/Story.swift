import Foundation

public struct Story: Decodable {
    public let id: Int
    public let title: String?
    public let description: String?
}
