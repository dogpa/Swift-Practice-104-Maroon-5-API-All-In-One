//
//  Twitter JSON.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//

import Foundation

//解析上方推特主介紹ＪＳＯＮ
struct TwitterScreenJSON: Codable {
    let name: String                    //名字首字大寫
    let screen_name: String             //名字
    let location: String                //註冊地點
    let description: String             //介紹
    let url: URL                        //魔力紅官網
    let followers_count: Int            //被追蹤者人數
    let friends_count:Int               //追蹤者朋友
    let created_at: String              //建立日期後續要轉換
    let profile_image_url_https: URL    //大頭貼照片
    let profile_banner_url: URL         //封面照
    let entities: Entities
    let status: Status
    struct Entities:Codable {
        let description: Description
        struct Description: Codable {
            let urls: [Urls]
            struct Urls: Codable {
                let url: URL?           //linktree
            }
        }
    }
    
    struct Status: Codable {
        let text: String
        
    }
}


//解析推文內容ＪＳＯＮ
struct TwitterTweetJSON : Codable {
    let created_at: String      //建立日期
    let text: String            //推文內文
    let retweet_count: Int      //轉貼
    let favorite_count: Int     //喜歡
}
