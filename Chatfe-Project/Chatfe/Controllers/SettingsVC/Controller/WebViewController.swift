//
//  WebViewController.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 01/07/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - ==== VARIABLEs ====
    var strTitle = ""
    var strURL = ""
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = strTitle
        if let url = URL(string: strURL) {
            webView.load(URLRequest(url: url))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

    // MARK: - ==== IBACTIONs ====
    @IBAction func closeBtnClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
