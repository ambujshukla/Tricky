//
//  ContactModel.swift
//  ContactPicker
//
//  Created by gopalsara on 20/05/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import Contacts


struct EPGlobalConstants {
    
    //MARK: String Constants
    struct Strings {
        static let birdtdayDateFormat = "MMM d"
        static let contactsTitle = "Contacts"
        static let phoneNumberNotAvaialable = "No phone numbers available"
        static let emailNotAvaialable = "No emails available"
        static let bundleIdentifier = "EPContactsPicker"
        static let cellNibIdentifier = "EPContactCell"
    }
}
class ContactModel: NSObject {
    
    var firstName: String
    var lastName: String
    var company: String
    var thumbnailProfileImage: UIImage?
    var profileImage: UIImage?
    var birthday: Date?
    var birthdayString: String?
    var contactId: String?
    var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
    var emails = [(email: String, emailLabel: String )]()
    var email: String?
    var fullName : String?
    
    
    public init (contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        company = contact.organizationName
        contactId = contact.identifier
        fullName = contact.givenName + " " + contact.familyName
        
        if let thumbnailImageData = contact.thumbnailImageData {
            thumbnailProfileImage = UIImage(data:thumbnailImageData)
        }
        
        if let imageData = contact.imageData {
            profileImage = UIImage(data:imageData)
        }
        
        if let birthdayDate = contact.birthday {
            
            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = EPGlobalConstants.Strings.birdtdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday!)
        }
        
        for phoneNumber in contact.phoneNumbers {
            guard let phoneLabel = phoneNumber.label else { continue }
            let phone = phoneNumber.value.stringValue
            
            phoneNumbers.append((phone,phoneLabel))
        }
        
        //        for emailAddress in contact.emailAddresses {
        //            guard let emailLabel = emailAddress.label else { continue }
        //            let email = emailAddress.value as String
        //
        //            emails.append((email,emailLabel))
        //        }
    }
    
    open func displayName() -> String {
        return firstName + " " + lastName
    }
    
    open func contactInitials() -> String {
        var initials = String()
        
        if let firstNameFirstChar = firstName.characters.first {
            initials.append(firstNameFirstChar)
        }
        
        if let lastNameFirstChar = lastName.characters.first {
            initials.append(lastNameFirstChar)
        }
        
        return initials
    }
    
}
