import Foundation

public enum MarvelError: Error {
	case encoding
	case decoding
	case server(message: String)
}
