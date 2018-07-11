//
//  MomentVC.swift
//  DouYin
//
//  Created by Niu Changming on 7/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MomentVC: UITableViewController {
    
    var moments: [Moment] = []
    let cellID = "MomentCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "MomentCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        dimData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MomentCell
        let moment: Moment = self.moments[indexPath.row]
        
        cell.updateUI(moment: moment)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dimData(){
        let comment1 = Comment()
        comment1.author = "王二麻"
        comment1.content = "这是什么东西呀，我怎么没看过！"
        
        let comment2 = Comment()
        comment2.author = "王二麻"
        comment2.content = "我昨天逛街看到你和你两位的老公了！"
        
        let comment3 = Comment()
        comment3.author = "妈妈"
        comment3.content = "今晚回家吃饭哈😄"
        
        
        let moment1 = Moment()
        moment1.author = "ZhangSan"
        moment1.avatarLink = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDzLOpZHeOceHTTDjkzrhpTQnpA28LijJ_zjH7rb_z8Mk11jmX"
        moment1.body = "因为对这两国来说有一场更加重要的比赛，就在那一瞬间，开哨了！12点钟的时候美方开了球，或者说打响了贸易战，当然也可以叫贸易摩擦的“第一枪”，一分钟之后，来而不往非礼也，中国不止是防守也开始了传控和相关的进攻，也开始反制。"
        moment1.type = 0;
        moment1.time = 1530978285049
        moment1.comments = [comment1, comment2]
        self.moments.append(moment1)
        
        let moment2 = Moment()
        moment2.author = "小明"
        moment2.avatarLink = "http://www.shuaigetuku.com/uploadfile/2017/0425/20170425013954916.jpg"
        moment2.body = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
        moment2.type = 1;
        moment2.time = 1530978295049
        let link2 = Link()
        link2.link = "http://www.shuaigetuku.com/show-10-66-1.html"
        link2.icon = "http://p1.ifengimg.com/a/2018/0420/c49f8f0f43579ebsize4_w50_h58.jpg"
        link2.title = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
        moment2.link = link2
        moment2.comments = [comment1]
        self.moments.append(moment2)
        
        let moment3 = Moment()
        moment3.author = "小明"
        moment3.avatarLink = "http://www.shuaigetuku.com/uploadfile/2017/0425/20170425013954916.jpg"
        moment3.body = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
        moment3.type = 2;
        moment3.time = 1530978295049
        moment3.pictures = ["https://pic.pimg.tw/nixojov/1466125488-1841874269_n.jpg?v=1466127109", "https://tw.bring-you.info/imgs/2015/04/%E9%AB%98%E9%9B%84%E7%BE%8E%E9%A3%9F%E5%A5%BD%E5%90%83%E6%AF%94%E8%96%A9-16.jpg", "https://d2j3coy501s4ze.cloudfront.net/images/11511/700/ff42ba91ff49e2309d4a35cc5c305c934b626d0e_57e8ca8b49d96.jpeg", "http://www.travel141.cn/wp-content/uploads/2017/05/shutterstock_323327855-768x512.jpg", "https://img.stillcarol.tw/20171001172350_98.jpg", "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Marina_Bay_Sands_in_the_evening_-_20101120.jpg/294px-Marina_Bay_Sands_in_the_evening_-_20101120.jpg", "https://content.shopback.com/tw/wp-content/uploads/2017/06/04222054/aotaro.jpg"]
        moment3.comments = [comment1, comment2, comment3]
        self.moments.append(moment3)
    }
    
}
