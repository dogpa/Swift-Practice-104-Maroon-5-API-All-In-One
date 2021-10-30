//
//  SongWebViewController.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//


import UIKit
import WebKit

class SongWebViewController: UIViewController {

    @IBOutlet weak var songWebKitView: WKWebView!
    
    var index: Int?                                 //前一頁的按到tableview的row數
    var webData = [SpotifyTopTrackJSON.TopTracks]() //整個熱門專輯的JSON資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //透過指派按到的row進去webData找出網址後透過webView顯示
        if index != nil {
            let songUrl = webData[index!].external_urls.spotify
            let request = URLRequest(url: songUrl)
            songWebKitView.load(request)
        }
    }


}
