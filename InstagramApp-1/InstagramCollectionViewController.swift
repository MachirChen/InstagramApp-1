//
//  InstagramCollectionViewController.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/24.
//

import UIKit

private let reuseIdentifier = "InstagramCollectionViewCell"

class InstagramCollectionViewController: UICollectionViewController {
    
    var instagramData: InstagramResponse?
    var instagramPostPicture = [InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    //透過IBSeguAction傳遞選中圖片的相關貼文資訊
    @IBSegueAction func showPostDetail(_ coder: NSCoder) -> InstagramPostDetailCollectionViewController? {
        
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else {return nil}
        
        return InstagramPostDetailCollectionViewController.init(coder: coder, instagramData: instagramData!, indexPath: row)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        //要採用storyboard裡設計的cell，所以下面這行可以刪除或註解掉
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        fetchInstagramData()
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
    //設定Section數量
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //設定Cell數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostPicture.count
    }

    //設定照片牆 Cell 顯示的相關訊息
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //先將cell轉型成自訂型別
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? InstagramCollectionViewCell else { return UICollectionViewCell()}
        
        let item = instagramPostPicture[indexPath.item]
        //再透過URLSession在背景抓Post圖片，最後使用DispatchQueue.main.async顯示在主畫面
        URLSession.shared.dataTask(with: item.node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.showImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    
        return cell
    }
    
    //回傳ReusableView顯示的內容
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //參數ofKind設定為Header類型，參數withReuseIdentifier則是輸入CollectionReusableView的ID，最後將resuableView轉型成自訂型別
        guard let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InstagramHeaderCollectionReusableView", for: indexPath) as? InstagramHeaderCollectionReusableView else { return UICollectionReusableView() }
        
        //透過URLSession在背景抓簡介的圖片，最後使用DispatchQueue.main.async顯示在主畫面，並且設定圖片圓角，使圖片顯示為圓型
        if let profilPicUrl = self.instagramData?.graphql.user.profile_pic_url_hd {
            URLSession.shared.dataTask(with: profilPicUrl) { data, response, error in
                if let data = data {
                    do {
                        DispatchQueue.main.async {
                            resuableView.profilePicImageView.layer.cornerRadius = resuableView.profilePicImageView.frame.width / 2
                            resuableView.profilePicImageView.image = UIImage(data: data)
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
        
        if let postCount = self.instagramData?.graphql.user.edge_owner_to_timeline_media.count,
           let followCount = self.instagramData?.graphql.user.edge_followed_by.count,
           let followingCount = self.instagramData?.graphql.user.edge_follow.count,
           let fullName = self.instagramData?.graphql.user.username,
           let biography = self.instagramData?.graphql.user.biography {
            resuableView.postsLabel.text = numCoverter(postCount) //貼文數量
            resuableView.followersLabel.text = numCoverter(followCount) //粉絲人數
            resuableView.followingLabel.text = numCoverter(followingCount) //追蹤者
            resuableView.fullNameLabel.text = "\(fullName)" //名稱
            resuableView.biographyTextView.isEditable = false
            resuableView.biographyTextView.text = "\(biography)" //自傳
        }
        return resuableView
    }
    
    func fetchInstagramData() {
        let urlStr = "https://www.instagram.com/btoday_ig/?__a=1"
        if let url = URL(string: urlStr) {
            //運用background thread抓取資料
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder() //利用JSONDecoder將型別Data的JSON資料變成型別InstagramResponse
                decoder.dateDecodingStrategy = .secondsSince1970 //解析時間
                if let data = data {
                    do {
                        let instagramResponse = try decoder.decode(InstagramResponse.self, from: data)
                        self.instagramData = instagramResponse
                        //運用DispatchQueue將資料顯示到主畫面
                        DispatchQueue.main.async {
                            self.instagramPostPicture = (self.instagramData?.graphql.user.edge_owner_to_timeline_media.edges)!
                            self.navigationItem.title = self.instagramData?.graphql.user.username
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    print("error")
                }
            }.resume()
        }
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
