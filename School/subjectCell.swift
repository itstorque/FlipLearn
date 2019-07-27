//
//  subjectCell.swift
//  School
//
//  Created by Tareq El Dandachi on 5/12/17.
//  Copyright © 2017 Tareq El Dandachi. All rights reserved.
//

import UIKit

class subjectCell: UITableViewCell {
    
    let label : UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        label = UILabel(frame: CGRect.null)
        label.textColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
