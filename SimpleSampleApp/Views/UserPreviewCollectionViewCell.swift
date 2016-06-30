//
//  UserPreviewCollectionViewCell.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/29/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit

class UserPreviewCollectionViewCell: UICollectionViewCell {
    var companyNameLabel:UILabel!
    var nameLabel:UILabel!
    var emailLabel:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLabels()
    }

    func setupLabels() {
        backgroundColor = UIColor(red: 133.0/255.0, green: 208.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        companyNameLabel = UILabel(frame: CGRectMake(8.0, 8.0, 0.0, 0.0))
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightMedium)

        nameLabel = UILabel(frame: CGRectMake(150.0, 86.0, 0.0, 0.0))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Zapfino", size: 16.0)
        emailLabel = UILabel(frame: CGRectMake(150.0, 86.0, 0.0, 0.0))
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFontOfSize(12.0)
        addSubview(companyNameLabel)
        addSubview(nameLabel)
        addSubview(emailLabel)

        companyNameLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 8.0).active = true
        companyNameLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 8.0).active = true

        nameLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: 0.0).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: 0.0).active = true

        emailLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: 0.0).active = true
        emailLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor).active = true
    }

    func fillAndRearrangeLabelsForUser(user:User) {
        nameLabel.text = user.name
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(bounds.size.width/2.0 - nameLabel.bounds.size.width/2.0,
                                     bounds.size.height/2.0 - nameLabel.bounds.size.height/2.0,
                                     nameLabel.bounds.size.width,
                                     nameLabel.bounds.size.height)

        emailLabel.text = user.email
        emailLabel.sizeToFit()
        emailLabel.frame = CGRectMake(bounds.size.width/2.0 - emailLabel.bounds.size.width/2.0,
                                      nameLabel.frame.origin.y + nameLabel.bounds.size.height,
                                      emailLabel.bounds.size.width,
                                      emailLabel.bounds.size.height)

        if let company = user.company {
            companyNameLabel.text = company.name
            companyNameLabel.sizeToFit()
        }
    }
}
