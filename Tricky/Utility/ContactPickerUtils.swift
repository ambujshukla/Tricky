//
//  ContactPicker.swift
//  ContactPicker
//
//

import UIKit
import Contacts

let keysToFetch = [
    CNContactBirthdayKey,
    CNContactDatesKey,
    CNContactDepartmentNameKey,
    CNContactEmailAddressesKey,
    CNContactFamilyNameKey,
    CNContactGivenNameKey,
    CNContactIdentifierKey,
    CNContactImageDataAvailableKey,
    CNContactImageDataKey,
    CNContactInstantMessageAddressesKey,
    CNContactJobTitleKey,
    CNContactMiddleNameKey,
    CNContactNamePrefixKey,
    CNContactNameSuffixKey,
    CNContactNicknameKey,
    CNContactNonGregorianBirthdayKey,
    CNContactNoteKey,
    CNContactOrganizationNameKey,
    CNContactPhoneNumbersKey,
    CNContactPhoneticFamilyNameKey,
    CNContactPhoneticGivenNameKey,
    CNContactPhoneticMiddleNameKey,
    CNContactPostalAddressesKey,
    CNContactPreviousFamilyNameKey,
    CNContactRelationsKey,
    CNContactSocialProfilesKey,
    CNContactThumbnailImageDataKey,
    CNContactTypeKey,
    CNContactUrlAddressesKey,
]



typealias ContactsHandler = (_ contacts : NSMutableArray , _ error : NSError?) -> Void


class ContactPickerUtils: NSObject {

    var contactsStore: CNContactStore?

    
    class var  sharedContactPicker: ContactPickerUtils {
        struct Static
        {
            static var onceToken : Int = 0
            static var instance : ContactPickerUtils? = nil
        }
        
        if !(Static.instance != nil) {
            
            Static.instance = ContactPickerUtils()
        }
        
        return Static.instance!
    }

   
    func getContctFromContactBook( target : UIViewController ,_ completion:  @escaping ContactsHandler) {
      
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            //User has denied the current app to access the contacts.
            
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            
            let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {  action in
                
                target.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            
            target.present(alert, animated: true, completion: nil)
            
        case CNAuthorizationStatus.notDetermined:
            //This case means the user is prompted for the first time for allowing contacts
            contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                if  (!granted ){
                 
                    DispatchQueue.main.async {
                        target.navigationController?.popViewController(animated: true)
                    }
                }
                else{
               self.getContctFromContactBook(target: target , completion)
                    
                }
            })
        case  CNAuthorizationStatus.authorized:
            //Authorization granted by user for this app.
            let contactsArray = NSMutableArray()
            
            let contactFetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
            
            do {
                try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                   
                   // if (contact.emailAddresses.count > 0) {
                    for emailAddress in contact.phoneNumbers {
                        let contactModel  = ContactModel(contact : contact)
                        contactModel.email = ""
                        contactsArray.add(contactModel)
                        }// }
                })
                completion(contactsArray, nil)
            }
            catch _ as NSError {
            //    print(error.localizedDescription)
            }
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
        ]
    }

    
    
}
