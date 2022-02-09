//
//  MainCell.swift
//  MySample
//
//  Created by SCpeng on 2022/1/13.
//

import UIKit

struct Sample {
    let title: String
    let source: String
}

class MainCell: UITableViewCell {

    @IBOutlet var lab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
