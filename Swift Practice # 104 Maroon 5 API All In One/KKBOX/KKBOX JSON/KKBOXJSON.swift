//
//  KKBOXJSON.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//


import Foundation


//對應歌手資訊
struct KKBOXSingerJSON: Codable {
    let id: String
    let name: String
    let url: URL
    let images: [Images]
    struct Images:Codable {
        let url: URL
    }
}

//對應歌手搜尋結果
struct KKBOXSearchJSON:Codable {
    let tracks: Tracks
    struct Tracks:Codable {
        let data: [SearchData]              //12首熱門歌曲
        struct SearchData:Codable {
            let id: String
            let name: String                //歌名
            let url: URL                    //歌曲網址
            let album: Ablum                //歌曲專輯
            struct Ablum:Codable {
                let images: [Images]        //歌曲專輯封面照
                struct Images:Codable {
                    let url:URL
                }
            }
        }
        
    }
}

