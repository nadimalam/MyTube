//
//  VideoTableViewCell.swift
//  MyTube
//
//  Created by Nadim Alam on 03/02/2019.
//  Copyright © 2019 Nadim Alam. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(video: Video) {
        titleLabel.text = video.title
        
        if let url = URL(string: video.thumbnailUrl) {
            // Download image on background thread.
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    // Update the image on main thread.
                    DispatchQueue.main.sync {
                        self.previewImageView.image = UIImage(data: data)
                    }
                } catch {
                    print("Error downloading image")
                }
            }
        }
    }
}
