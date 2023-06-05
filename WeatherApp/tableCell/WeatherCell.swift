//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Zibew on 01/06/23.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var distancLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func dataSource(item : SearchModal?){
        self.nameLbl.text = "\(item?.name ?? "") \(item?.country ?? "")"
        self.distancLbl.text = "\(item?.lat ?? 0.0)-\(item?.lon ?? 0.0)"
    }
    
}
