//
//  InstagramCollectionViewCell.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/24.
//

import UIKit

class InstagramCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var cellWidthConstraints: NSLayoutConstraint!
    
    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
    //產生cell時，會先呼叫func awakeFromNib，在此設定cell依據iphone螢幕大小做計算，每張間距為3，一排有3張。
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidthConstraints?.constant = Self.width
    }
    
    
}
