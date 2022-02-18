//
//  TestData.swift
//  MySample
//
//  Created by Evan Peng on 2022/2/18.
//

import Foundation

struct TestData: Decodable {

  let data: String
  let nowTime: String
  
  enum CodingKeys: String, CodingKey {
    case data = "data"
    case nowTime
  }
}
