//
//  InstagramResponse.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/25.
//

import Foundation

struct InstagramResponse: Codable {
    let graphql: Graphql
    struct Graphql: Codable {
        let user: User
        struct User: Codable {
            let biography: String  //自我介紹
            
            let edge_followed_by: Edge_followed_by  //粉絲人數
            struct Edge_followed_by: Codable {
                let count: Int
            }
            
            let edge_follow: Edge_follow  //追蹤者數量
            struct Edge_follow: Codable {
                let count: Int
            }
            
            let full_name: String  //使用者名稱
            let profile_pic_url_hd: URL  //頭像
            let username: String  //使用者帳號
            
            let edge_felix_video_timeline: Edge_felix_video_timeline //影片貼文資料
            struct Edge_felix_video_timeline: Codable {
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let video_url: URL
                    }
                }
            }
            
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        
                        let display_url: URL //圖片網址
                        
                        let edge_media_to_caption: Edge_media_to_caption  //圖片貼文標題
                        struct Edge_media_to_caption: Codable {
                            let edges: [Edges]
                            struct Edges: Codable {
                                var node: Node
                                struct Node: Codable {
                                    var text: String
                                }
                            }
                        }
                        
                        let edge_media_to_comment: Edge_media_to_comment //貼文貼文留言數
                        struct Edge_media_to_comment: Codable {
                            let count: Int
                        }
                        
                        let edge_liked_by: Edge_liked_by //圖片貼文按讚數
                        struct Edge_liked_by: Codable {
                            let count: Int
                        }
                        
                        let taken_at_timestamp: Date //圖片貼文時間
                    }
                }
            }
        }
    }
}
