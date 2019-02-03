//
//  APIService.swift
//  MyTube
//
//  Created by Nadim Alam on 03/02/2019.
//  Copyright © 2019 Nadim Alam. All rights reserved.
//

import Foundation
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
}

class APIService {
    
    // YouTube API key from console
    // https://console.developers.google.com/apis/credentials?project=mytube-ios-app&supportedpurview=project
    let API_KEY = "AIzaSyAXyPt0yWTwvdnRZMgQWHCaF2ygcgNAE_E"
    let YOUTUBE_PLAYLIST_URL = "https://www.googleapis.com/youtube/v3/playlistItems"
    
    var videoArray = [Video]()
    var delegate : VideoModelDelegate?
    
    func fetchVideos(playlistID: String) {
        
        // Fetch the video dynamically through the YouTube Data API.
        Alamofire.request((YOUTUBE_PLAYLIST_URL),
                          parameters: ["part": "snippet",
                                       "playlistId": playlistID,
                                       "maxResults": "50",
                                       "key": API_KEY],
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            
            if let JSON = response.result.value {
                var arrayOfVideos = [Video]()
                
                for video in (JSON as! NSDictionary)["items"] as! NSArray {
                    
                    var videoObj = Video(id: "", title: "", description: "", thumbnailUrl: "")                    
                    
                    if let videoId = (video as! NSDictionary).value(forKeyPath: "snippet.resourceId.videoId") {
                        videoObj.id = videoId as! String
                    }
                    
                    if let videoTitle = (video as! NSDictionary).value(forKeyPath: "snippet.title") {
                        videoObj.title = videoTitle as! String
                    }
                    
                    if let videoDescription = (video as! NSDictionary).value(forKeyPath: "snippet.description") {
                        videoObj.description = videoDescription as! String
                    }
                    
                    if let thumbnailURL = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.standard.url") {
                        videoObj.thumbnailUrl = thumbnailURL as! String
                    }
                    
                    arrayOfVideos.append(videoObj)
                }
                self.videoArray = arrayOfVideos
                
                // Notify the delegate that the data is ready.
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
        }
    }
}
