import Foundation

struct CharacterSeriesRequest: APIRequest {
    typealias Response = [Series]
    
    var resourceName: String {
        return "characters/\(characterId)/series"
    }
    
    private let characterId: Int
    private let limit: Int?
    
    init(characterId: Int, limit: Int? = nil) {
        self.characterId = characterId
        self.limit = limit
    }
}
