import Foundation

class CharactersClient: CharactersClientProtocol {
    private let httpClient: HTTPAPIClient
    
    init(httpClient: HTTPAPIClient) {
        self.httpClient = httpClient
    }
    
    func getCharacters(_ comicsRequest: CharactersRequest, completion: @escaping (Result<DataContainer<CharactersRequest.Response>>) -> Void) {
        httpClient.send(comicsRequest, completion: completion)
    }
    
    func getComics(_ comicRequest: CharacterComicsRequest, completion: @escaping (Result<DataContainer<CharacterComicsRequest.Response>>) -> Void) {
        httpClient.send(comicRequest, completion: completion)
    }
    
    func getEvents(_ eventRequest: CharacterEventsRequest, completion: @escaping (Result<DataContainer<CharacterEventsRequest.Response>>) -> Void) {
        httpClient.send(eventRequest, completion: completion)
    }
    
    func getSeries(_ seriesRequest: CharacterSeriesRequest, completion: @escaping (Result<DataContainer<CharacterSeriesRequest.Response>>) -> Void) {
        httpClient.send(seriesRequest, completion: completion)
    }
    
    func getStories(_ storiesRequest: CharacterStoriesRequest, completion: @escaping (Result<DataContainer<CharacterStoriesRequest.Response>>) -> Void) {
        httpClient.send(storiesRequest, completion: completion)
    }
}
