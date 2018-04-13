import Foundation

protocol CharactersClientProtocol {
    func getCharacters(_ comicsRequest: CharactersRequest, completion: @escaping (Result<DataContainer<CharactersRequest.Response>>) -> Void)
    func getComics(_ comicRequest: CharacterComicsRequest, completion: @escaping (Result<DataContainer<CharacterComicsRequest.Response>>) -> Void)
    func getEvents(_ eventRequest: CharacterEventsRequest, completion: @escaping (Result<DataContainer<CharacterEventsRequest.Response>>) -> Void)
    func getSeries(_ seriesRequest: CharacterSeriesRequest, completion: @escaping (Result<DataContainer<CharacterSeriesRequest.Response>>) -> Void)
    func getStories(_ storiesRequest: CharacterStoriesRequest, completion: @escaping (Result<DataContainer<CharacterStoriesRequest.Response>>) -> Void)
}
