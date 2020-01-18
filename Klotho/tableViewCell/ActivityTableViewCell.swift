//
//  ActivityTableViewCell.swift
//  PM Junior
//
//  Created by Decimo B on 7/26/19.
//  Copyright © 2019 project Manager. All rights reserved.
//

import Foundation
import UIKit

class ActivityTableViewCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "activityCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
