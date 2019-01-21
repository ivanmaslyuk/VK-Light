//
//  ConversationsViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {

    //var conversations : [VKGetConversationsResponse.Item] = []
    //var vkResponse : VKGetConversationsResponse?
    var dialogs = [VKDialogWrapper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "Диалоги"
        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 80, bottom: 0, right: 0)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        MessageHelper().loadDialogs(count: 50, offset: 0, completion: { (response, error) in
            if let response = response {
                self.dialogs = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationCell
        let wrapper = dialogs[indexPath.row]
        
        cell.dialogWrapper = wrapper
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDialog", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true
        if segue.identifier == "showDialog" {
            // в sender получаем индекс выбранного диалога
            if let destination = segue.destination as? DialogViewController {
                let conInfo = dialogs[sender as! Int]
                destination.dialogWrapper = conInfo
            }
        }
    }

}
