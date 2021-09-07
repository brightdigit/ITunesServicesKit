//
//  File.swift
//  
//
//  Created by Mark Struzinski on 6/14/19.
//

import Foundation
import Prch

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

public final class Request: APIRequest<Response> {
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
