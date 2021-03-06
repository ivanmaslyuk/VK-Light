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
        let template = "https://oauth.vk.com/authorize?client_id=6752052&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,messages,offline&response_type=token&v=5.80"
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
        /*let resp = (response.split(separator: "#")[1]).split(separator: "=")[1]
        let token = resp.split(separator: "&")[0]
        
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "vk_token")*/
        let right = response.split(separator: "#")[1]
        let parameters = right.split(separator: "&")
        
        var values : Dictionary<String, String> = [:]
        for parameter in parameters {
            let parts = parameter.split(separator: "=")
            values[String(parts[0])] = String(parts[1])
        }
        
        let defaults = UserDefaults.standard
        defaults.set(values["access_token"], forKey: "vk_token")
        defaults.set(values["user_id"], forKey: "vk_user_id")
    }
    
    func openConversationsList() {
        /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let conversationsViewController = storyBoard.instantiateViewController(withIdentifier: "conversationsViewController")
        self.present(conversationsViewController, animated: false, completion: nil)*/
        performSegue(withIdentifier: "loginSuccess", sender: nil)
        //self.navigationController?.pushViewController(conversationsViewController, animated: true)
    }
    
}

