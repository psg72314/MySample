//
//  MainVC.swift
//  MySample
//
//  Created by SCpeng on 2022/1/13.
//

import UIKit

class MainVC: UIViewController {
    //test
    @IBOutlet var tableView: UITableView!
    
    var data = [Sample(title: "CoreData Demo", source: "CoreDataVC"),
                Sample(title: "SQLite Demo", source: "SQLiteVC"),
                Sample(title: "Alamofire", source: "AlamofirerSample"),
                Sample(title: "Moya", source: "class"),
                Sample(title: "Kingfisher", source: "class"),]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "sample"
        tableView.backgroundColor = UIColor.white
        tableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    // Extensions must not contain stored properties
    //var a = 1
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
    }

    func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    // 知识点：向下转型
    // as! 强制类型转换，无法转换时会抛出运行时异常
    // as？可选类型转换，无法转换时返回nil
    let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
    let sample = data[indexPath.row]

        cell.lab.text = sample.title
        cell.backgroundColor = UIColor.white


    return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(data[indexPath.row])
        
        let sample_class = data[indexPath.row].source
        
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"]as? String else{
            return debugPrint("JYGetPushVc 调用 pushVcByVcNameAndTitle, namespace不存在")
        }
        let clsName = namespace + "." + sample_class
        //print(clsName)
        guard let cls = NSClassFromString(clsName) as? UIViewController.Type else{
            return debugPrint("JYGetPushVc 调用 pushVcByVcNameAndTitle, 项目中没有控制器 === CoreDataVC")
        }
        let vc = cls.init()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
