import Foundation

struct CharacterStoriesRequest: APIRequest {
    typealias Response = [Story]
    
    var resourceName: String {
        return "characters/\(characterId)/stories"
    }
    
    private let characterId: Int
    private let limit: Int?
    
    init(characterId: Int, limit: Int? = nil) {
        self.characterId = characterId
        self.limit = limit
    }
}
