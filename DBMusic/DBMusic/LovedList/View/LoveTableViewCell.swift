//
//  LoveTableViewCell.swift
//  DBMusic
//
//  Created by ldjhust on 15/10/3.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class LoveTableViewCell: UITableViewCell {

  var thumbImageView: UIImageView!
  var titleLabel: UILabel!
  var artistLabel: UILabel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.thumbImageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 50, height: 50))
    self.titleLabel = UILabel(frame: CGRect(x: 75, y: 10, width: 200, height: 25))
    self.artistLabel = UILabel(frame: CGRect(x: 75, y: 35, width: 200, height: 25))
    
    self.addSubview(self.thumbImageView)
    self.addSubview(self.titleLabel)
    self.addSubview(self.artistLabel)
  }

  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
