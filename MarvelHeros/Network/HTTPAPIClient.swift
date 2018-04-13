import Foundation

class HTTPAPIClient {
	private let baseEndpoint = "https://gateway.marvel.com:443/v1/public/"
	private let session = URLSession(configuration: .default)

	private let publicKey: String
	private let privateKey: String

	public init(publicKey: String, privateKey: String) {
		self.publicKey = publicKey
		self.privateKey = privateKey
	}

	func send<T: APIRequest>(_ request: T, completion: @escaping (Result<DataContainer<T.Response>>) -> Void) {
        guard let endpoint = self.endpoint(for: request) else { return }

        let task = session.dataTask(with: URLRequest(url: endpoint)) { data, _, error in
			if let data = data {
				do {
					let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)

					if let dataContainer = marvelResponse.data {
						completion(.success(dataContainer))
					} else if let message = marvelResponse.message {
						completion(.failure(MarvelError.server(message: message)))
					} else {
						completion(.failure(MarvelError.decoding))
					}
				} catch {
					completion(.failure(error))
				}
			} else if let error = error {
				completion(.failure(error))
			}
		}
		task.resume()
	}

	private func endpoint<T: APIRequest>(for request: T) -> URL? {
		guard let parameters = try? URLQueryEncoder.encode(request) else { fatalError("Wrong parameters") }

		let timestamp = Date().timeIntervalSince1970
        guard let hash = "\(timestamp)\(privateKey)\(publicKey)".md5 else { return nil }

        return URL(string: "\(baseEndpoint)\(request.resourceName)?ts=\(timestamp)&hash=\(hash)&apikey=\(publicKey)&\(parameters)")
	}
}
