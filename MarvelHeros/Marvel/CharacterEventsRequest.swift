import Foundation

struct CharacterEventsRequest: APIRequest {
    typealias Response = [Event]
    
    var resourceName: String {
        return "characters/\(characterId)/events"
    }
    
    private let characterId: Int
    private let limit: Int?
    
    init(characterId: Int, limit: Int? = nil) {
        self.characterId = characterId
        self.limit = limit
    }
}
