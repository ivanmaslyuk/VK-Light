//
//  ViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 14/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let template = "https://oauth.vk.com/authorize?client_id=6752052&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,messages&response_type=token&v=5.52"
        let url = URL(string: template)!
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }


    
}

extension ViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url
        var response : String = (url?.absoluteString)!
        /*do {
        response = try String(contentsOf: url!)
        }
        catch let error {
            print(error)
        }*/
        
        if response.contains("#access_token=") {
            saveAccessToken(response: response)
            openConversationsList()
        }
    }
    
    func saveAccessToken(response: String) {
        let resp = (response.split(separator: "#")[1]).split(separator: "=")[1]
        
        let token = resp.split(separator: "&")[0]
        
        VKHttpRequestLayer.accessToken = String(token)
    }
    
    func openConversationsList() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let conversationsViewController = storyBoard.instantiateViewController(withIdentifier: "conversationsViewController") as! ConversationsViewController
        self.present(conversationsViewController, animated: false, completion: nil)
        //self.navigationController?.pushViewController(conversationsViewController, animated: true)
    }
    
}

