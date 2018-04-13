import Foundation

public struct DataContainer<Results: Decodable>: Decodable {
	public let offset: Int
	public let limit: Int
	public let total: Int
	public let count: Int
	public let results: Results

	public init(offset: Int = 0,
	            limit: Int = 0,
	            total: Int = 0,
	            count: Int = 0,
	            results: Results) {
		self.offset = offset
		self.limit = limit
		self.total = total
		self.count = count
		self.results = results
	}
}
