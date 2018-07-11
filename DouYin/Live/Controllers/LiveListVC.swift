//
//  LiveListVC.swift
//  DouYin
//
//  Created by Niu Changming on 26/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SDWebImage

class LiveListVC: UITableViewController {
    
    let liveData = LiveData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveData.getData { [unowned self] (message) in
            if message == "Success" {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveData.flow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell", for: indexPath) as! LiveCell
        cell.selectionStyle = .none;
        cell.fillCell = liveData.flow[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveVC: LiveVC = LiveVC()
        liveVC.live = liveData.flow[indexPath.row]
        liveVC.currentIndex = indexPath.row
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.present(liveVC, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260 * Constants.Dimension.H_RATIO
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
