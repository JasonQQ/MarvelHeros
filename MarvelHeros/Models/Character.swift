import Foundation

public struct Character: Decodable {
    public let id: Int
    public let name: String?
    public let description: String?
    public let thumbnail: Image?
    
    public init(id: Int = 0,
                name: String? = nil,
                description: String? = nil,
                thumbnail: Image? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}
