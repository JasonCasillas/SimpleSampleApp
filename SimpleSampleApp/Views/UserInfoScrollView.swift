//
//  UserInfoScrollView.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit

class UserInfoScrollView: UIScrollView {

    var allLabels: [UILabel]!
    var personalInfoLabel: UILabel = UILabel()
    var addressInfoLabel: UILabel = UILabel()
    var companyInfoLabel: UILabel = UILabel()
    var basePadding:CGFloat = 8.0
    var labelGap:CGFloat = 24.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLabels()
    }

    func setupLabels() {
        allLabels = [personalInfoLabel, addressInfoLabel, companyInfoLabel]
        for (index,label) in allLabels.enumerate() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(17.0)
            label.lineBreakMode = .ByWordWrapping
            label.frame = CGRectMake(basePadding, basePadding+(CGFloat(index)*labelGap), self.bounds.size.width - basePadding * 2.0, 0.0)
            label.minimumScaleFactor = 1.0
            addSubview(label)
        }

        personalInfoLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: basePadding).active = true
        personalInfoLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: basePadding).active = true
        personalInfoLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: basePadding).active = true
        addressInfoLabel.leadingAnchor.constraintEqualToAnchor(personalInfoLabel.leadingAnchor).active = true
        addressInfoLabel.trailingAnchor.constraintEqualToAnchor(personalInfoLabel.trailingAnchor).active = true
        addressInfoLabel.topAnchor.constraintEqualToAnchor(personalInfoLabel.bottomAnchor, constant: labelGap).active = true
        companyInfoLabel.leadingAnchor.constraintEqualToAnchor(addressInfoLabel.leadingAnchor).active = true
        companyInfoLabel.trailingAnchor.constraintEqualToAnchor(addressInfoLabel.trailingAnchor).active = true
        companyInfoLabel.topAnchor.constraintEqualToAnchor(addressInfoLabel.bottomAnchor, constant: labelGap).active = true
        companyInfoLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: labelGap).active = true
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func fillAndRearrangeLabelsForUser(user:User) {
        let personalInfoLabelText = [user.name, user.username, user.email, user.phone, user.website].flatMap{$0}.joinWithSeparator("\n")

        personalInfoLabel.text = personalInfoLabelText
        personalInfoLabel.sizeToFit()
        personalInfoLabel.frame = CGRectMake(personalInfoLabel.frame.origin.x,
                                             personalInfoLabel.frame.origin.y,
                                             self.bounds.size.width - basePadding * 2.0,
                                             personalInfoLabel.bounds.size.height)

        if let address = user.address as? Address {
            let cityZipText = [address.city, address.zipcode].flatMap{$0}.joinWithSeparator(", ")
            let latitudeLongitudeText = [address.city, address.zipcode].flatMap{$0}.joinWithSeparator(", ")
            let addressInfoLabelText = [address.street, address.suite, cityZipText, latitudeLongitudeText].flatMap{$0}.joinWithSeparator("\n")

            addressInfoLabel.text = addressInfoLabelText
            addressInfoLabel.sizeToFit()
            addressInfoLabel.frame = CGRectMake(addressInfoLabel.frame.origin.x,
                                                personalInfoLabel.frame.origin.y+personalInfoLabel.bounds.size.height+labelGap,
                                                self.bounds.size.width - basePadding * 2.0,
                                                addressInfoLabel.bounds.size.height)
        }

        if let company = user.company {
            let companyInfoLabelText = [company.name, company.catchPhrase, company.bs].flatMap{$0}.joinWithSeparator("\n")

            companyInfoLabel.text = companyInfoLabelText
            companyInfoLabel.sizeToFit()
            companyInfoLabel.frame = CGRectMake(companyInfoLabel.frame.origin.x,
                                                addressInfoLabel.frame.origin.y+addressInfoLabel.bounds.size.height+labelGap,
                                                self.bounds.size.width - basePadding * 2.0,
                                                companyInfoLabel.bounds.size.height)
        }
    }
}
