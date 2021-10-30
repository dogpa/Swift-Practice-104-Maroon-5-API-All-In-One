//
//  KKBOXTableViewController.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//

import UIKit

class KKBOXTableViewController: UITableViewController {
    
    
    @IBOutlet weak var singerPhotoImageView: UIImageView!
    
    var maroon5InfoDataFormJSON: KKBOXSingerJSON?
    var maroonTrackDataFromJSON = [KKBOXSearchJSON.Tracks.SearchData]()
    
    func getKKBOXMaroon5Data () {
        
        let JSONDecoder = JSONDecoder()
        JSONDecoder.dateDecodingStrategy = .iso8601
        
        //搜尋結果
        var maroon5SearchRequest = URLRequest(url: URL(string: "https://api.kkbox.com/v1.1/search?q=Maroon5&type=track&territory=TW")!,timeoutInterval: Double.infinity)
        maroon5SearchRequest.addValue("Bearer KuMTNM-5g3ssVdljB565Tg==", forHTTPHeaderField: "Authorization")

        maroon5SearchRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: maroon5SearchRequest) {data, response, error in
            if let maroonData = data {
                do{
                    //print(String(data: maroonData, encoding: .utf8)!)
                    let maroon5TrackResponse = try JSONDecoder.decode(KKBOXSearchJSON.self, from: maroonData)
                    self.maroonTrackDataFromJSON = maroon5TrackResponse.tracks.data
                    print("track success")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                    print("track fail")
                }
            }
        }.resume()
        
        
        //歌手資料
        var maroon5InfoRequest = URLRequest(url: URL(string: "https://api.kkbox.com/v1.1/artists/GqcMIJigyaDAnAypxQ?territory=TW")!, timeoutInterval: Double.infinity)
        
        maroon5InfoRequest.addValue("Bearer ", forHTTPHeaderField: "Authorization")

        maroon5InfoRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: maroon5InfoRequest) { data, response, error in
            if let maroonInfoData = data {
                do{
                    //print(String(data: maroonInfoData, encoding: .utf8))
                    let singerResponse = try JSONDecoder.decode(KKBOXSingerJSON.self, from: maroonInfoData)
                    self.maroon5InfoDataFormJSON = singerResponse
                    print("singer success")
                    URLSession.shared.dataTask(with: self.maroon5InfoDataFormJSON!.images[1].url){ data, response, error in
                        if let maroonPhotoData = data {
                            DispatchQueue.main.sync {
                                self.singerPhotoImageView.image = UIImage(data: maroonPhotoData)
                            }
                        }
                    }.resume()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print("singer fail")
                    print(error)
                }
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        singerPhotoImageView.layer.cornerRadius = singerPhotoImageView.frame.height / 2
        getKKBOXMaroon5Data ()
        print(maroonTrackDataFromJSON)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return maroonTrackDataFromJSON.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingerTrackTableViewCell", for: indexPath) as? SingerTrackTableViewCell else {return UITableViewCell()}
        cell.songNameLabel.text = maroonTrackDataFromJSON[indexPath.row].name
        URLSession.shared.dataTask(with: maroonTrackDataFromJSON[indexPath.row].album.images[1].url) { data, response, error in
            if let albumPhoto = data {
                DispatchQueue.main.async {
                    cell.albumImageView.image = UIImage(data: albumPhoto)
                }
            }
        }.resume()
        
        
        return cell
    }
    
    
    //跳頁面到下一頁
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSong", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            if let webVC = segue.destination as? SongViewController {
                let selectIndex = self.tableView.indexPathForSelectedRow
                if let selectRow = selectIndex?.row {
                    webVC.index = selectRow
                    webVC.dataFromPage = maroonTrackDataFromJSON
                }
            }
        }
    }
    
    
}
