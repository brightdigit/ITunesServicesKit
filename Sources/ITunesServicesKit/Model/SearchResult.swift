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

public typealias MediaType = Void

public final class Request: APIRequest<Response> {
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
  public let term : String = ""
  public let country: Locale =  Locale(identifier: "US")
  public let mediaType : MediaType = ()
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
//  limit
//  The number of search results you want the iTunes Store to return. For example: 25. The default is 50.
//  N
//  1 to 200
//  lang
//  The language, English or Japanese, you want to use when returning search results. Specify the language using the five-letter codename. For example: en_us. The default is en_us (English).
//  N
//  en_us, ja_jp
//  version
//  The search result key version you want to receive back from your search. The default is 2.
//  N
//  1,2
//  explicit
  // A flag indicating whether or not you want to include explicit content in your search results. The default is Yes.
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
