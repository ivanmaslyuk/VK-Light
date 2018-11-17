//
//  ViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 14/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let template = "https://oauth.vk.com/authorize?client_id=6752052&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,messages,offline&response_type=token&v=5.52"
        let url = URL(string: template)!
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }


    
}

extension AuthViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url
        let response : String = (url?.absoluteString)!
        
        if response.contains("#access_token=") {
            saveAccessToken(response: response)
            openConversationsList()
        }
    }
    
    func saveAccessToken(response: String) {
        let resp = (response.split(separator: "#")[1]).split(separator: "=")[1]
        let token = resp.split(separator: "&")[0]
        
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "vk_token")
        
        //VKHttpRequestLayer.accessToken = String(token)
    }
    
    func openConversationsList() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let conversationsViewController = storyBoard.instantiateViewController(withIdentifier: "conversationsViewController")
        self.present(conversationsViewController, animated: false, completion: nil)
        //self.navigationController?.pushViewController(conversationsViewController, animated: true)
    }
    
}

