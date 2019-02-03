//
//  ViewController.swift
//  MyTube
//
//  Created by Nadim Alam on 03/02/2019.
//  Copyright © 2019 Nadim Alam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var playlistButtons: [UIButton]!
    
    var videos = [Video]()
    let apiService = APIService()
    var refreshControl: UIRefreshControl!
    
    let btnOriginalColor = UIColor(rgb: 0x531A58, alphaVal: 1)
    let btnSelectedColor = UIColor.white
    
    // MARK: - YouTube playlist url ids
    let LIKED_VIDEOS_PLAYLIST_ID = "LLaGR2wC486_NBA_171ZPxMQ"
    let MY_VIDEOS_PLAYLIST_ID = "UUaGR2wC486_NBA_171ZPxMQ"
    let FAV_VIDEOS_PLAYLIST_ID = "FLaGR2wC486_NBA_171ZPxMQ"
    
    // MARK: - App View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom protocol has been setup in APIService class.
        apiService.delegate = self
        apiService.fetchVideos(playlistID: MY_VIDEOS_PLAYLIST_ID)
        
        setupRefreshUI()
    }
    
    func setupRefreshUI() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for:UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Button Actions
    @IBAction func myVideosBtnPressed(_ sender: UIButton) {
        updatePlaylistButtonsUI(sender)
        apiService.fetchVideos(playlistID: MY_VIDEOS_PLAYLIST_ID)
    }
    
    @IBAction func likedVideosBtnPressed(_ sender: UIButton) {
        updatePlaylistButtonsUI(sender)
        apiService.fetchVideos(playlistID: LIKED_VIDEOS_PLAYLIST_ID)
    }
    
    @IBAction func favVideosBtnPressed(_ sender: UIButton) {
        updatePlaylistButtonsUI(sender)
        apiService.fetchVideos(playlistID: FAV_VIDEOS_PLAYLIST_ID)
    }
    
    func updatePlaylistButtonsUI(_ sender: UIButton) {
        for button in playlistButtons {
            button.setTitleColor(btnOriginalColor, for: .normal)
        }
        sender.setTitleColor(btnSelectedColor, for: .normal)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeDetailViewController {
            if let video = sender as? Video {
                destination.video = video
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell {
            // Get the video object from the array.
            let video = videos[indexPath.row]
            // Update the UI of the video cell.
            cell.updateUI(video: video)
            return cell
        }
        // Return default cell incase the custom video cell doesnt exist.
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        performSegue(withIdentifier: "HomeDetailViewController", sender: video)
    }
}

// Mark: - VideoModel Delegate and Methods
extension HomeViewController: VideoModelDelegate {
    
    func dataReady() {
        // Access the video objects that have been downloaded
        videos = apiService.videoArray
        
        // Reload the tableView
        tableView.reloadData()
    }
}
