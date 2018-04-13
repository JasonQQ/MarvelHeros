import Foundation

public struct Image: Decodable {
	enum ImageKeys: String, CodingKey {
		case path = "path"
		case fileExtension = "extension"
	}

	public let url: URL

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ImageKeys.self)

		let path = try container.decode(String.self, forKey: .path)
		let fileExtension = try container.decode(String.self, forKey: .fileExtension)

		guard let url = URL(string: "\(path).\(fileExtension)") else { throw MarvelError.decoding }

		self.url = url
	}
}
