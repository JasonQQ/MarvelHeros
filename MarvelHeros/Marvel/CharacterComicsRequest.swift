import Foundation

struct CharacterComicsRequest: APIRequest {
	typealias Response = [Comic]

	var resourceName: String {
        return "characters/\(characterId)/comics"
	}

	private let characterId: Int
    private let limit: Int?

	init(characterId: Int, limit: Int? = nil) {
		self.characterId = characterId
        self.limit = limit
	}
}
