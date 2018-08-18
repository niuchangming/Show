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
    
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action:
//            #selector(LiveListVC.handleRefresh(_:)),
//                                 for: UIControlEvents.valueChanged)
//        refreshControl.tintColor = UIColor.red
//
//        return refreshControl
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        liveData.getData { [unowned self] (status) in
            if status == .success {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.liveData.data .removeAll()
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveData.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell", for: indexPath) as! LiveCell
        cell.selectionStyle = .none;
        cell.fillCell = liveData.data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveVC: LiveVC = LiveVC()
        liveVC.live = liveData.data[indexPath.row]
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
