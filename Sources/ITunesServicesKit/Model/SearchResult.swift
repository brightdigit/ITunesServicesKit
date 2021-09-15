//
//  File.swift
//  
//
//  Created by Mark Struzinski on 6/14/19.
//

import Foundation
import Prch

public struct iTunes: API {
  
  public let baseURL = URL(string: "https://itunes.apple.com")!
  
  public let headers = [String : String]()
  
  public let decoder : ResponseDecoder = JSONDecoder()
  
  
}


public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
  
  

  
  public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
    switch statusCode {
    case 200: self = try .status200(decoder.decode(SearchResponse.self, from: data))
    default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
    }
  }
  
  
  public typealias SuccessType = SearchResponse
  
  case status200(SearchResponse)
  
  public var success: SearchResponse? {
    switch self {
    case let .status200(response): return response
    }
  }

  public var response: Any {
    switch self {
    case let .status200(response): return response
    }
  }

  public var statusCode: Int {
    switch self {
    case .status200: return 200
    }
  }

  public var successful: Bool {
    switch self {
    case .status200: return true
    }
  }

  public var description: String {
    "\(statusCode) \(successful ? "success" : "failure")"
  }

  public var debugDescription: String {
    var string = description
    let responseString = "\(response)"
    if responseString != "()" {
      string += "\n\(responseString)"
    }
    return string
  }
  
}

public struct MediaEntity {
  let mediaType : MediaType
  let entity : Entity?
  
  public enum Movie {
    static let artist : MediaEntity = .init(mediaType: .movie, entity: .movieArtist)
    static let movie : MediaEntity = .init(mediaType: .movie, entity: .movie)
    static let `default` : MediaEntity = .init(mediaType: .movie, entity: nil)
  }
  
  public enum Podcast {
    static let author : MediaEntity = .init(mediaType: .podcast, entity:.podcastAuthor)
    static let podcast : MediaEntity = .init(mediaType: .podcast, entity:.podcast)
    static let `default` : MediaEntity = .init(mediaType: .podcast, entity: nil)
  }
  
  public enum Music {
    public static let  artist : MediaEntity = .init(mediaType: .music, entity:.musicArtist)
    public static let  track : MediaEntity = .init(mediaType: .music, entity:.musicTrack)
    public static let  album : MediaEntity = .init(mediaType: .music, entity:.album)
    public static let  video : MediaEntity = .init(mediaType: .music, entity:.musicVideo)
    public static let  mix : MediaEntity = .init(mediaType: .music, entity:.mix)
    public static let  song : MediaEntity = .init(mediaType: .music, entity:.song)
    static let `default` : MediaEntity = .init(mediaType: .music, entity: nil)
  }
  
  public enum MusicVideo {
    public static let  artist : MediaEntity = .init(mediaType: .musicVideo, entity:.musicArtist)
    public static let  video : MediaEntity = .init(mediaType: .musicVideo, entity:.musicVideo)
    static let `default` : MediaEntity = .init(mediaType: .musicVideo, entity: nil)
  }
  
  public enum Audiobook {
    public static let audiobookAuthor : MediaEntity = .init(mediaType: .audiobook, entity: .audiobookAuthor)
    public static let audiobook : MediaEntity = .init(mediaType: .audiobook, entity: .audiobook)
    static let `default` : MediaEntity = .init(mediaType: .audiobook, entity: nil)
  }
  
  
  public enum ShortFilm {
    public static let shortFilmArtist : MediaEntity = .init(mediaType: .shortFilm, entity: .shortFilmArtist)
    public static let   shortFilm : MediaEntity = .init(mediaType: .shortFilm, entity: .  shortFilm)
    static let `default` : MediaEntity = .init(mediaType: .shortFilm, entity: nil)
  }
  
  public enum TvShow {
    public static let tvEpisode : MediaEntity = .init(mediaType: .tvShow, entity: .tvEpisode)
    public static let tvSeason : MediaEntity = .init(mediaType: .tvShow, entity: .  tvSeason)
    static let `default` : MediaEntity = .init(mediaType: .tvShow, entity: nil)
  }
  
  public enum Software {
    public static let software : MediaEntity = .init(mediaType: .software, entity: .software)
    public static let iPadSoftware : MediaEntity = .init(mediaType: .software, entity: .  iPadSoftware)
    public static let macSoftware : MediaEntity = .init(mediaType: .software, entity: .  macSoftware)
    static let `default` : MediaEntity = .init(mediaType: .software, entity: nil)
  }

  public enum EBook {
    public static let ebook : MediaEntity = .init(mediaType: .ebook, entity: .ebook)
    static let `default` : MediaEntity = .init(mediaType: .ebook, entity: nil)
  }
  
  public enum All {
    public static let movie : MediaEntity = .init(mediaType: .all, entity: .movie)
    public static let album : MediaEntity = .init(mediaType: .all, entity: .album)
    public static let allArtist : MediaEntity = .init(mediaType: .all, entity: .allArtist)
    public static let podcast : MediaEntity = .init(mediaType: .all, entity: .podcast)
    public static let musicVideo : MediaEntity = .init(mediaType: .all, entity: .musicVideo)
    public static let mix : MediaEntity = .init(mediaType: .all, entity: .mix)
    public static let audiobook : MediaEntity = .init(mediaType: .all, entity: .audiobook)
    public static let tvSeason : MediaEntity = .init(mediaType: .all, entity: .tvSeason)
    public static let allTrack : MediaEntity = .init(mediaType: .all, entity: .allTrack)
  }









}
internal enum MediaType : String {
  case movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
}
public enum Language : String {
  case english = "en_us"
  case japanese = "ja_jp"
}

public enum Version : Int {
  case v1 = 1
  case v2 = 2
}

internal enum Entity : String {
  //movie
  case movieArtist, movie
  // podcast
  case podcastAuthor, podcast
  // music
  case musicArtist, musicTrack, album, musicVideo, mix, song
  // Please note that “musicTrack” can include both songs and music videos in the results
  // musicVideo
  //case musicArtist, musicVideo
  // audiobook
  case audiobookAuthor, audiobook
  // shortFilm
  case shortFilmArtist, shortFilm
  // tvShow
  case tvEpisode, tvSeason
  // software
  case software, iPadSoftware, macSoftware
  // ebook
  case ebook
  // all
  //case movie, album, allArtist, podcast, musicVideo, mix, audiobook, tvSeason,
  case allArtist, allTrack
  

}

extension Dictionary {
  mutating func trim () -> Self {
    for (key, value) in self {
      if self[key] == nil {
        self.removeValue(forKey: key)
      }
    }
    return self
  }
}

public final class Request: APIRequest<Response> {
  internal init(
    term: String,
    country: Locale? = nil,
    mediaType: MediaType? = nil,
    entity: Entity? = nil,
    limit: Int? = nil,
    language: Language? = nil,
    version: Version? = nil,
    explicit: Bool? = nil) {
      self.term = term
    self.country = country
    self.mediaType = mediaType
      self.entity = entity
    self.limit = limit
    self.language = language
    self.version = version
    self.explicit = explicit
      super.init(service: Self.service)
  }
  
  public init(
    term: String,
    country: Locale? = nil,
    mediaEntity: MediaEntity? = nil,
    limit: Int? = nil,
    language: Language? = nil,
    version: Version? = nil,
    explicit: Bool? = nil) {
      self.term = term
    self.country = country
      self.mediaType = mediaEntity?.mediaType
      self.entity = mediaEntity?.entity
    self.limit = limit
    self.language = language
    self.version = version
    self.explicit = explicit
      super.init(service: Self.service)
  }
  
  public static let service = APIService<Response>(id: "Bulk Remove a List of Issues", tag: "", method: "GET", path: "/search/", hasBody: false, securityRequirements: [])
  
//  term
//  The URL-encoded text string you want to search for. For example: jack+johnson.

  
  
//  Y
//  Any URL-encoded text string.
//  Note: URL encoding replaces spaces with the plus (+) character and all characters except the following are encoded: letters, numbers, periods (.), dashes (-), underscores (_), and asterisks (*).
//  country
//  The two-letter country code for the store you want to search. The search uses the default store front for the specified country. For example: US. The default is US.
//  Y
//  See http://en.wikipedia.org/wiki/ ISO_3166-1_alpha-2 for a list of ISO Country Codes.
//  media
//  The media type you want to search for. For example: movie. The default is all.
//  N
//  movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
//  entity
//  The type of results you want returned, relative to the specified media type. For example: movieArtist for a movie media type search. The default is the track entity associated with the specified media type.
//  N
  public let term : String
  public let country: Locale?
  let mediaType : MediaType?
  let entity: Entity?
//  For a list of available entitites, see Table 2-1.
//  attribute
//  The attribute you want to search for in the stores, relative to the specified media type. For example, if you want to search for an artist by name specify entity=allArtist&attribute=allArtistTerm. In this example, if you search for term=maroon, iTunes returns “Maroon 5” in the search results, instead of all artists who have ever recorded a song with the word “maroon” in the title.
//  The default is all attributes associated with the specified media type.
//  N
//  For a list of available attributes, see Table 2-2.
//  callback
//  The name of the Javascript callback function you want to use when returning search results to your website.
//  Y, for cross-site searches
//  wsSearchCB
  public let limit : Int?
//  limit
//  The number of search results you want the iTunes Store to return. For example: 25. The default is 50.
//  N
//  1 to 200
//  lang
//  The language, English or Japanese, you want to use when returning search results. Specify the language using the five-letter codename. For example: en_us. The default is en_us (English).
  public let language : Language?
//  N
//  en_us, ja_jp
//  version
//  The search result key version you want to receive back from your search. The default is 2.
//  N
//  1,2
  public let version : Version?
//  explicit
  // A flag indicating whether or not you want to include explicit content in your search results. The default is Yes.
  public let explicit : Bool?
  
  public override var queryParameters: [String : Any] {
    var parameters = [String : Any]()
    parameters["term"] = term
    parameters["country"] = country?.regionCode
    parameters["mediaType"] = mediaType
    parameters["entity"] = entity
    parameters["limit"] = limit
    parameters["language"] = language
    parameters["version"] = version
    parameters["explicit"] = explicit
    return parameters.trim()
  }
//  let queryItems = [
//    URLQueryItem(name: "term", value: term),
//    URLQueryItem(name: "media", value: "software"),
//    URLQueryItem(name: "country", value: "US")


//return EndPoint(path: "/us/search",
//                queryItems: queryItems)
}

public struct SearchResult: Decodable {
    public let id: Int
    public let trackName: String?
    public let artistName: String?
    private let artworkURL100: URL?
}

extension SearchResult {
    private enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkURL100 = "artworkUrl100"
    }
}

extension SearchResult {
    func artworkURL(size dimension: Int = 100) -> URL? {
        guard dimension > 0, dimension != 100,
            var url = artworkURL100 else {
            return artworkURL100
        }
        
        url.deleteLastPathComponent()
        url.appendPathComponent("\(dimension)x\(dimension)bb.jpg")
        
        return url
    }
}

extension SearchResult: Identifiable {}
