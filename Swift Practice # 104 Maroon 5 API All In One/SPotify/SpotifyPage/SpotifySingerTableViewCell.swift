//
//  SpotifySingerTableViewCell.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//


import UIKit

class SpotifySingerTableViewCell: UITableViewCell {

    @IBOutlet weak var trackSongName: UILabel!              //歌曲名稱
    
    @IBOutlet weak var trackAlbumImageView: UIImageView!    //專輯封面照
        
    @IBOutlet weak var releaseDateLabel: UILabel!           //發布日label
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
