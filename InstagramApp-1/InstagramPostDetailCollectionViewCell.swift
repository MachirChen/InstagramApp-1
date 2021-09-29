//
//  InstagramPostDetailCollectionViewCell.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/25.
//

import UIKit

class InstagramPostDetailCollectionViewCell: UICollectionViewCell {
    
    var likeButtonStatus:Bool = false
    
    @IBOutlet weak var showPostImageView: UIImageView!
    @IBOutlet weak var showProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    @IBOutlet weak var postCaptionTextView: UITextView!
    @IBOutlet weak var postLikeLabel: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    
    @IBAction func postLikeAction(_ sender: Any) {
     likeButtonStatus = !likeButtonStatus
        if likeButtonStatus {
            postLikeButton.setImage(UIImage(named: "iconRedLove"), for: UIControl.State.normal)
        } else {
            postLikeButton.setImage(UIImage(named: "iconLove"), for: UIControl.State.normal)
        }
    }
}
