//
//  SpotifyTableViewController.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//

import UIKit

class SpotifyTableViewController: UITableViewController {

    
    @IBOutlet weak var singerImageView: UIImageView!
    
    
    var dataFromToken: TokenJSON?                               //新token的JSON
    var dataFromTopTrack =  [SpotifyTopTrackJSON.TopTracks]()   //track熱門歌曲
    var dataFromTopTrackAlbum: SpotifyTopTrackAlbumJSON?        //專輯JSON
    var dataFromSingerInfo: SpotifySingerInfoJSON?              //歌手JSON
    var bearer: String?                                         //存每次抓到的新token
    
    //取得新token 歌手資訊 熱門歌曲 Fcuction
    func getTokenAndJSONFromSpotify () {
        
    //取得token開始
        
        let parameters = "grant_type=refresh_token&refresh_token=AQDL8NBXgWS0Gewkj9kfF96jeeDrnRdMBpKs2YLyM3k5_OdgXAHoH2WoIF27Icdpo6JRLRu1WcjQ8OegPKS4m6wvhh6eqrLmS24QBhBrrChtoTicNiGn3mnb5ONGLJubVHI"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!,timeoutInterval: Double.infinity)
        request.addValue("Basic 同意後的網址code", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("__Host-device_id=AQCRmhAO28NUlVhehq5ALeXWUxZu50bBgajyisgv94WgP-sSg3Mwxciu24Ot0WfJ7VvKD5F0_t1s_Wh9jRPLkhDQZcsf978Pn1Y; sp_tr=false", forHTTPHeaderField: "Cookie")
        //httpMethod為Post後回傳資料
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let tokendata = data {
                let JSONDecoder = JSONDecoder()
                JSONDecoder.dateDecodingStrategy = .iso8601

                do{
                    let tokenResponse = try JSONDecoder.decode(TokenJSON.self, from: tokendata)
                    self.dataFromToken = tokenResponse
                    print("get token success")
                    
                }catch{
                    print(error)
                    print("get token fail")
                }

                //將bearer指派為新的token讓後續的JSON可以透過這個token使用
                if  self.dataFromToken != nil {
                    self.bearer = "\(String(describing: self.dataFromToken!.token_type)) \(String(describing: self.dataFromToken!.access_token))"
                    
                }
        //取得token結束
                
                
                //透過新token取得track排行榜JSON開始
                var maroonTopTrackRequest = URLRequest(url: URL(string: "https://api.spotify.com/v1/artists/04gDigrS5kc9YWfZHwBETP/top-tracks?country=TW")!, timeoutInterval: Double.infinity)
                maroonTopTrackRequest.addValue("\(self.bearer!)", forHTTPHeaderField: "Authorization")
                maroonTopTrackRequest.httpMethod = "GET"
                URLSession.shared.dataTask(with: maroonTopTrackRequest) { data, response, error in
                    if let topTrackdata = data {
                        do {
                            //print(String(data: topTrackdata, encoding: .utf8)!)
                            let topTrackResponse = try JSONDecoder.decode(SpotifyTopTrackJSON.self, from: topTrackdata)
                            self.dataFromTopTrack = topTrackResponse.tracks
                            print(topTrackResponse)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            print("maroon topTrack success\n")
                        }catch{
                            print(error)
                            print("maroon topTrack fail\n")
                        }
                    }
                }.resume()  //執行取得track排行榜JSON
                //取得track排行榜JSON開始結束
                
                
                //透過新token取得singerInfo歌手資料JSON開始
                var maroonFiveSingerRequest = URLRequest(url: URL(string: "https://api.spotify.com/v1/artists/04gDigrS5kc9YWfZHwBETP")!, timeoutInterval: Double.infinity)
                maroonFiveSingerRequest.addValue("\(self.bearer!)", forHTTPHeaderField: "Authorization")
                maroonFiveSingerRequest.httpMethod = "GET"
                URLSession.shared.dataTask(with: maroonFiveSingerRequest) { data, response, error in
                    if let singerInfodata = data {
                        do{
                            let singerInfoResponse = try JSONDecoder.decode(SpotifySingerInfoJSON.self, from: singerInfodata)
                            self.dataFromSingerInfo = singerInfoResponse
                            print("get singerInfo Success")
                            URLSession.shared.dataTask(with: self.dataFromSingerInfo!.images[0].url) {data , response, error in
                                if let singerPhotoData = data {
                                    DispatchQueue.main.async {
                                        self.singerImageView.image = UIImage(data: singerPhotoData)
                                    }
                                }
                            }.resume()
                        }catch{
                            print(error)
                            print("get singerInfo fail")
                        }
                    }
                }.resume()
                
                //取得singerInfo歌手資料JSON結束
                
            }
        }.resume()          //執行取得tokenJSON
                            //整體抓JSON Function結束
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        singerImageView.contentMode = .scaleAspectFill
        getTokenAndJSONFromSpotify()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFromTopTrack.count
    }

    //tableView顯示資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpotifySingerTableViewCell", for: indexPath) as? SpotifySingerTableViewCell else {return UITableViewCell()}
        //取得歌曲名稱
        cell.trackSongName.text = dataFromTopTrack[indexPath.row].name
        
        //取得照片
        URLSession.shared.dataTask(with: dataFromTopTrack[indexPath.row].album.images[0].url) {data , response, error in
            if let AlbumPhoto = data {
                DispatchQueue.main.async {
                    cell.trackAlbumImageView.image = UIImage(data: AlbumPhoto)
                }
            }
        }.resume()
        
        
        //透過token再取得專輯JSON內的發布日後指派給cell.releaseDateLabel.text
        var maroonReleaseDateRequest = URLRequest(url: URL(string: "\(dataFromTopTrack[indexPath.row].album.href)")!)
        maroonReleaseDateRequest.addValue("\(self.bearer!)", forHTTPHeaderField: "Authorization")
        maroonReleaseDateRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: maroonReleaseDateRequest) {data, response, error in
            if let releaseDateData = data{
                let JSONDecoder = JSONDecoder()
                
                do {
                    let releaseDateResponse = try JSONDecoder.decode(SpotifyTopTrackAlbumJSON.self, from: releaseDateData)
                    self.dataFromTopTrackAlbum = releaseDateResponse
                    DispatchQueue.main.async {
                        cell.releaseDateLabel.text = self.dataFromTopTrackAlbum!.release_date
                    }
                    
                    print("get releaseDate success")
                }catch{
                    print(error)
                    print("get releaseDate fail")
                }
            }
        }.resume()
        
        return cell
    }
    
    //跳頁面到下一頁
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSong", sender: nil)
    }
    
    //透過 segue.identifier == "showSong"將資料傳到下一頁
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            if let webVC = segue.destination as? SongWebViewController {
                let selectIndex = self.tableView.indexPathForSelectedRow
                if let selectRow = selectIndex?.row {
                    //兩個下一頁需要的資料
                    webVC.index = selectRow
                    webVC.webData = dataFromTopTrack
                }
            }
        }
    }
     

}

