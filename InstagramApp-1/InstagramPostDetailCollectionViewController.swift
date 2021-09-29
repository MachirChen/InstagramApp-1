//
//  InstagramPostDetailCollectionViewController.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/25.
//

import UIKit

private let reuseIdentifier = "InstagramPostDetailCollectionViewCell"

class InstagramPostDetailCollectionViewController: UICollectionViewController {

    @IBOutlet weak var postCollectionView: UICollectionView!
    
    var instagramPostInfo: InstagramResponse.Graphql.User.Edge_owner_to_timeline_media
    var instagramProfileUserName: String
    var instagramProfilePicURL: URL
    var indexPath: Int
    var isShow = false
    //資料是從storyboard生成，將呼叫init(coder:)
    init?(coder: NSCoder, instagramData: InstagramResponse, indexPath: Int) {
        self.instagramPostInfo = instagramData.graphql.user.edge_owner_to_timeline_media
        self.instagramProfileUserName = instagramData.graphql.user.username
        self.instagramProfilePicURL = instagramData.graphql.user.profile_pic_url_hd
        self.indexPath = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //強制App閃退
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigation Title運用兩行文字
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        let userNameUpper = self.instagramProfileUserName.uppercased()
        label.text = "\(userNameUpper)\n Posts"
        self.navigationItem.titleView = label

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //要採用storyboard裡設計的cell，所以下面這行可以刪除或註解掉
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            collectionView.scrollToItem(at: IndexPath(item: self.indexPath, section: 0), at: .top, animated: false)
            isShow = true
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostInfo.edges.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? InstagramPostDetailCollectionViewCell else { return UICollectionViewCell() }
    
        //抓Post圖片
        URLSession.shared.dataTask(with: instagramPostInfo.edges[indexPath.item].node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    //設定貼文圖片與用戶名間隔的線條
                    let border = CALayer()
                    border.backgroundColor = UIColor.systemGray3.cgColor
                    border.frame = CGRect(x: 0, y: 0, width: cell.showPostImageView.frame.width, height: 0.5)
                    cell.showPostImageView.layer.addSublayer(border)
                    cell.showPostImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        //抓Profile圖片
        URLSession.shared.dataTask(with: instagramProfilePicURL) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.showProfileImageView.layer.cornerRadius = cell
                        .showProfileImageView.frame.height / 2
                    cell.showProfileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        cell.userNameLabel.text = "\(instagramProfileUserName)"
        
        //init button icon
        cell.postLikeButton.setImage(UIImage(named: "iconLove"), for: UIControl.State.normal)
        
        let postLikeCount = numCoverter(instagramPostInfo.edges[indexPath.item].node.edge_liked_by.count)
        
        cell.postLikeLabel.text = "\(postLikeCount)"
        cell.postCaptionTextView.isEditable = false
        cell.postCaptionTextView.isScrollEnabled = false
        cell.postCaptionTextView.text = instagramPostInfo.edges[indexPath.item].node.edge_media_to_caption.edges[0].node.text
    
        let postCommentCount = numCoverter(instagramPostInfo.edges[indexPath.item].node.edge_media_to_comment.count)
        cell.postCommentCountLabel.textColor = .gray
        cell.postCommentCountLabel.text = "view all \(postCommentCount) comments"
        
        //Post Time Transfor
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: instagramPostInfo.edges[indexPath.item].node.taken_at_timestamp)
        cell.postDateLabel.text = "\(dateString)"
        return cell
        
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
