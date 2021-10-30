//
//   Spotify JSON.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//


import Foundation


struct TokenJSON: Codable {
    let access_token : String
    let token_type: String
}

//topTrack的JSON
struct SpotifyTopTrackJSON: Codable {
    let tracks: [TopTracks]
    struct TopTracks: Codable {
        
        let id: String                  //專輯在spotify內的名稱
        let name: String                //排行榜歌曲
        let album: Album
        let external_urls: External_urls
        
        struct Album: Codable {
            let href: URL
            let images: [Images]
            struct Images:Codable {
                let url: URL
            }
        }
        
        struct External_urls:Codable {
            let spotify: URL            //歌曲連結
        }
    }
}


//專輯的JSON
struct SpotifyTopTrackAlbumJSON: Codable {
    let release_date:String                 //發布日
    let images: [Images]
    struct Images:Codable {
        let url: URL
    }
}


//歌手資料的JSON
struct SpotifySingerInfoJSON: Codable {
    let name: String
    let external_urls: External_urls
    let images: [Images]
    struct External_urls: Codable {
        let spotify: URL
    }
    struct Images: Codable {
        let url: URL
    }
}
