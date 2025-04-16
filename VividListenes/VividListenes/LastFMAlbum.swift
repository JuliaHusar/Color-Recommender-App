//
//  LastFMAlbum.swift
//  VividListenes
//
//  Created by Julia Husar on 4/16/25.
//

import Foundation

struct LastFMResponse: Decodable {
    let dominant_colors_hsv: [[Double]]?
    let dominant_colors_rgb: [[Int]]?
    let top_ten_albums: TopTenAlbums?
    let error: String?
}

struct TopTenAlbums: Decodable {
    let topalbums: AlbumsInfo?
}

struct AlbumsInfo: Decodable {
    let album: [Album]?
}

struct Album: Decodable {
    let name: String
    let artist: Artist
    let image: [LastFMImage]
    
}

struct LastFMImage: Decodable {
    @available(*, deprecated, message: "Use url instead")
    let text: String?

    let url: String

    let size: String

    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
        case text
    }
}

struct Artist: Decodable {
    let mbid: String
    let name: String
    let url: String
}


struct ColorAPIResponse: Decodable{
    
    static func parseData(responseData: Data) -> LastFMResponse?{
        let decoder = JSONDecoder()

        do{
            let jsonData = try decoder.decode(LastFMResponse.self, from: responseData)
            if let jsonString = String(data: responseData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue) ?? .utf8){
                print("Raw JSON: \(jsonString)")
            }
            return jsonData.self
        } catch {
            if let jsonString = String(data: responseData, encoding: .utf8) {
                print("Raw JSON: \(jsonString)")
            }
            print(error)
            return nil
        }
    }
}
