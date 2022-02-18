//
//  Films.swift
//  MySample
//
//  Created by Evan Peng on 2022/2/18.
//

import Foundation

struct Films: Decodable {
  let count: Int
  let all: [Film]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
