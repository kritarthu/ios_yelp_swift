//
//  SwitchCell.swift
//  Yelp
//
//  Created by Kritarth Upadhyay on 7/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value:Bool)
}
class SwitchCell: UITableViewCell {
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var SwitchLabel: UILabel!
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }
}
