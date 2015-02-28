//
//  NewUOmeAddressBook.swift
//  UOless
//
//  Created by Rob Everhardt on 19/02/15.
//  Copyright (c) 2015 UOless. All rights reserved.
//

//See https://github.com/PaulSolt/Custom-UI-from-XIB-Xcode-6-IBDesignable/blob/master/Custom%20View%20from%20Xib/Custom%20View%20from%20Xib/Widget.swift

import UIKit

class NewUOmeAddressBook: UIView {

    @IBOutlet var requestAdressBookAccessButton: UIButton!
    
    @IBOutlet var detailLabel: UILabel!
    
    @IBAction func giveAccessButton(sender: AnyObject) {
        contacts.requestLocalAccess { (succeeded) -> () in
            self.updateFooter()
        }
    }
    
    override init(frame: CGRect) {
        // properties
        super.init(frame: frame)
        
        // Setup
        let view = UINib(nibName: "NewUOmeAdressBook", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as UIView
        self.opaque = false
        
        view.frame = self.bounds

        //view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
        

    }
    
    required init(coder aDecoder: NSCoder) {
        //fatalError("This class does not support NSCoding")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFooter()
    }
    
    func updateFooter() {
        //Determine address book status
        switch contacts.localStatus{
            case .Authorized:
                requestAdressBookAccessButton.hidden = true
                detailLabel.hidden = true
            case .Denied:
                requestAdressBookAccessButton.hidden = true
                detailLabel.hidden = false
                detailLabel.text = "You denied UOless access to your local address book, which is why we can only show contacts you've already exchanged UOmes with. You can allow access to your address book in the iOS settings (Privacy, Contacts)."
            case .NotDetermined:
                requestAdressBookAccessButton.hidden = false
                detailLabel.hidden = false
                detailLabel.text = "UOless will not upload any personal data from your contacts to its servers. The technical details: a salted hash of the email addresses and phone numbers of your contacts will at some point in the future created and stored at the servers, to be able to tell you who of your contacts is using our service."
            case .Restricted:
                requestAdressBookAccessButton.hidden = true
                detailLabel.hidden = false
                detailLabel.text = "UOless cannot access your contacts, possibly due to restrictions such as parental controls."
        }
    }

}
