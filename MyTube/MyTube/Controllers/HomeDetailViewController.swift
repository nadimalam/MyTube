//
//  HomeDetailViewController.swift
//  MyTube
//
//  Created by Nadim Alam on 03/02/2019.
//  Copyright © 2019 Nadim Alam. All rights reserved.
//

import UIKit
import WebKit

class HomeDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var _video : Video!
    // Getter/Setters private variables
    var video: Video { get { return _video } set { _video = newValue } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.loadHTMLString(video.linkURL, baseURL: nil)
        
        let url = NSURL(string: "https://www.youtube.com/watch?v=\(video.id)");
        let requestObj = NSURLRequest(url: url! as URL);
        
        descriptionTextView.text = video.description
        titleLabel?.text = video.title
        webView.load(requestObj as URLRequest)
        webView.scrollView.isScrollEnabled = false
    }
}
