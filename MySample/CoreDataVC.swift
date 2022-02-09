//
//  CoreDataVC.swift
//  MySample
//
//  Created by SCpeng on 2022/1/13.
//

import UIKit
import CoreData

class CoreDataVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    //宣告Core Data 常數
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //宣告一個Array，紀錄資料庫查詢出來的結果
    var memberList:[Member] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.memberList = self.selectObject()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        // Do any additional setup after loading the view.
    }

    @objc func  addUser() {
        
        self.showAlert(type:"新增", alertTitle: "新增人員資料", actionHandler: { (textFields: [UITextField]?) in
            DispatchQueue.main.async {
                self.insertObject(department: String(textFields?[0].text ?? ""), id: Int(textFields?[1].text ?? "") ?? 0, name: String(textFields?[2].text ?? ""))
            }
        })
    }
    
    //實作一個Alert 讓user輸入新增或編輯資料
   func showAlert(type:String, alertTitle: String, actionHandler: ((_ textFields: [UITextField]?) -> Void)? = nil) {
       let alert = UIAlertController.init(
           title:          alertTitle,
           message:        "",
           preferredStyle: .alert
       )
       
       //新增三個輸入框分別讓使用者輸入部門、編號、姓名
       for index in 0...2 {
           alert.addTextField { (textField:UITextField) in
               if index == 0 {
                   textField.placeholder = type + "部門"
               }else if index == 1 {
                   textField.placeholder = type + "編號"
               }else if index == 2 {
                   textField.placeholder = type + "姓名"
               }
           }
       }
       alert.addAction (UIAlertAction.init(title: "確定", style: .default, handler: { (action:UIAlertAction) in
           DispatchQueue.main.async {
               actionHandler?(alert.textFields)
           }
       }))
       
       let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { _ in
           DispatchQueue.main.async {

           }
       }
       alert.addAction(cancelAction)
       
       self.present(alert, animated: true, completion: nil)
   }
    
    //新增資料
    func insertObject(department: String, id: Int, name: String) {
        let member = NSEntityDescription.insertNewObject(forEntityName: "Member", into: self.context)as! Member
        member.id = Int32(id)
        member.name = name
        member.department = department
        do {
            try self.context.save()
        } catch {
            fatalError("\(error)")
        }
        //新增完畢後查詢資料庫資料並將資料庫資料顯示在TableView上
        self.memberList = self.selectObject()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //查詢資料
    func selectObject() -> Array<Member> {
        var array:[Member] = []
        let request = NSFetchRequest<Member>(entityName: "Member")
        do {
            let results = try self.context.fetch(request)
            for result in results {
                array.append(result)
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return array
        
    }
    //更新資料
    func updateObject(indexPath:IndexPath) {
        self.showAlert(type: "修改", alertTitle: "修改人員資料") { (textFields: [UITextField]?) in
            //更新:將查詢到的結果更新後，再呼叫context.save()儲存
            let request = NSFetchRequest<Member>(entityName: "Member")
            do {
                let results = try self.context.fetch(request)
                for item in results {
                    if item.id == self.memberList[indexPath.row].id &&
                        item.name == self.memberList[indexPath.row].name &&
                        item.department == self.memberList[indexPath.row].department {
                        
                        item.department = textFields?[0].text
                        item.id = Int32(Int(textFields?[1].text ?? "") ?? 0)
                        item.name = textFields?[2].text
                    }
                }
                try self.context.save()
            }catch{
                fatalError("Failed to fetch data: \(error)")
            }
            //新增完畢後查詢資料庫資料並將資料庫資料顯示在TableView上
            self.memberList = self.selectObject()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //刪除資料
    func deleteObject(indexPath:IndexPath) {
        //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
        let request = NSFetchRequest<Member>(entityName: "Member")
        do {
            let results = try self.context.fetch(request)
            for item in results {
                if item.id == self.memberList[indexPath.row].id &&
                    item.name == self.memberList[indexPath.row].name &&
                    item.department == self.memberList[indexPath.row].department {
                    context.delete(item)
                }
            }
            try self.context.save()
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        let alert = UIAlertController.init(
            title:          "已刪除",
            message:        "",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction.init(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: {
            //新增完畢後查詢資料庫資料並將資料庫資料顯示在TableView上
            self.memberList = self.selectObject()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension CoreDataVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Core Data 資料長度
        return self.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //顯示 Core Data 資料
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "編號：" + String(self.memberList[indexPath.row].id) + " , 部門：" + String(self.memberList[indexPath.row].department ?? "") + " , 姓名：" + String(self.memberList[indexPath.row].name ?? "")

        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //點擊cell 讓使用者選擇刪除或編輯資料
        let alert = UIAlertController.init(
            title:          "更新或刪除一筆資料",
            message:        "",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction.init(title: "更新", style: .default) { _ in
            DispatchQueue.main.async {
                self.updateObject(indexPath: indexPath)
            }
        }
        let cancelAction = UIAlertAction.init(title: "刪除", style: .default) { _ in
            DispatchQueue.main.async {
                self.deleteObject(indexPath: indexPath)
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    


}
