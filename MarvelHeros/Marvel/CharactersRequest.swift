import Foundation

struct CharactersRequest: APIRequest {
    typealias Response = [Character]
    
    var resourceName: String {
        return "characters"
    }
    
    private let name: String?
    private let nameStartsWith: String?
    private let limit: Int?
    private let offset: Int?
    
    init(name: String? = nil,
         nameStartsWith: String? = nil,
         limit: Int? = nil,
         offset: Int? = nil) {
        self.name = name
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
    }
}
