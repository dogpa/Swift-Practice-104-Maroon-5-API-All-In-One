//
//  IGAccountCollectionReusableView.swift
//  Swift Practice # 104 Maroon 5 API All In One
//
//  Created by Dogpa's MBAir M1 on 2021/10/30.
//


import UIKit

//在header區域拉出需要的ＩＢＯｕｔｌｅｔ
class IGAccountCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileHDPicImageView: UIImageView!      //大頭貼
    
    @IBOutlet weak var postLabel: UILabel!                      //貼文數
    
    @IBOutlet weak var follwersFansLabel: UILabel!              //粉絲數量
    
    @IBOutlet weak var follwerLabel: UILabel!                   //追蹤別人數量
    
    @IBOutlet weak var fullNameLabel: UILabel!                  //全名
    
    @IBOutlet weak var intrTextView: UITextView!                //自介紹
    
}

