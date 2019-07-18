//
//  MetricCell.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 10/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import UIKit

class MetricCell: UITableViewCell {

    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblTemperatureCelsius: UILabel!
    @IBOutlet weak var lblSensorTemperatureCelsius: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
