//
//  AlamofirerSample.swift
//  MySample
//
//  Created by SCpeng on 2022/2/8.
//

import UIKit
import Alamofire

class AlamofirerSample: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestTest2()
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
    
    func requestTest()
    {
        
        AF.request("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=e6831708-02b4-4ef8-98fa-4b4ce53459d9").response { response in
            
            switch response.result {
                case .success(let JSON):
                    do {
        
                        let JSONObject = try? JSONSerialization.jsonObject(with: JSON ?? Data(), options: .allowFragments)
                        //let jj = try? JSONSerialization.data(withJSONObject: JSON ?? Data(), options: [])
                        if let JSON = JSONObject as?  [String: Any] {
                                            let data: [String : Any]? = JSON["result"] as? [String : Any]
                                            let datalist: [[String : Any]]? = data!["results"]! as? [[String : Any]]
                                            //print("count: \(String(describing: data!["results"]!))")
                                            for data1 in datalist! {
                                                print("locationName: \(data1["locationName"]!)") // 所在縣市
                                                print("parameterName1: \(data1["parameterName1"]!)") // 天氣
                                                print("startTime: \(data1["startTime"]!)") // 起始時間
                                                print("endTime: \(data1["endTime"]!)") // 結束時間
                                                print()
                                            }
                                        }
                        
//                        let JSONObject = try? JSONSerialization.jsonObject(with: JSON ?? Data(), options: .allowFragments)
//                        if let JSON = JSONObject as? [String:Any] {
//                            debugPrint(JSON.debugDescription)
//                        }
                    }
                case .failure(let error):
                    debugPrint(error)

                }

        }
        
    }
    
    func requestTest2()
    {
        let parameters: Parameters = ["mode": "piG7qs5Taf3E1Meh/RiQOw=="]
        
        AF.request("https://app.police.taipei/Handler.ashx", method: .get, parameters: parameters).responseDecodable(of: TestData.self) { (response) in
            
            switch response.result
            {
            case .success(_): if let td = response.value {
                
                print("test data:\(td.data)")
            }
                case .failure(_): break
            }
            
        }
//        AF.request("http://www.google", method: .get, parameters: parameters).responseDecodable{
//            (response: DataResponse<T>) in
//            switch response.result
//            {
//                case .success(_):
//                    if let JSON = response.result.value as? [String: Any] {
//                                    let status = JSON["completed"] as! Bool
//                                    print(status)
//                                }
//                case .failure(_): break
//
//            }
//
//        }
    }
}
