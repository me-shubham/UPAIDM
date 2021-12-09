//
//  Constants.swift
//  u-paid-m
//
//  Created by Srajansinghal on 01/12/20.
//

import Foundation
import UIKit

let baseUrl = "https://api.hellenium.com/api"

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

let userDefaults = UserDefaults.standard
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let notificationCenter = NotificationCenter.default

struct UDKeys {
    static let isLogin = "isLogin"
    static let userId = "userId"
    static let userRoleID = "userRoleID"
    static let userAccountName = "userAccountName"
    static let transactionId = "transactionId"
    static let isAuthenticated = "isAuthenticated"
    static let setSkip = "setSkip"
    static let currencyType = "currencyType"
    static let currencyAmount = "currencyAmount"
    static let userFullName = "userFullName"
}

let ibanNumberDictionary = ["USD": ["iban": "GB29 REVO 0099 6998 5203 04","bic_code": "REVOGB21"], "EUR": ["iban": "GB29 REVO 0099 6998 5203 04","bic_code": ""], "GBP": ["iban": "44983875","bic_code": "04-00-75"], "CHF":["iban": "GB57 REVO 0099 6919 4599 50","bic_code": "REVOGB21"]]

func commonAlert(title:String, message:String ) -> UIAlertController
{
    let alert = UIAlertController.init(title:title, message: message, preferredStyle: .alert)
    alert .addAction(UIAlertAction.init(title:"OK", style: .cancel, handler: { (UIAlertAction) in

    }))
    return alert
}

func commonAlertWithAction(title:String, message:String, viewController:UIViewController ) -> UIAlertController
{
    let alert = UIAlertController.init(title:title, message: message, preferredStyle: .alert)
    alert .addAction(UIAlertAction.init(title:"OK", style: .cancel, handler: { (UIAlertAction) in
        viewController.navigationController?.popToRootViewController(animated: true)
    }))
    return alert
}

func commonAlertWithActionBack(title:String, message:String, viewController:UIViewController )-> UIAlertController
{
    let alert = UIAlertController.init(title:title, message: message, preferredStyle: .alert)
    alert .addAction(UIAlertAction.init(title:"OK", style: .cancel, handler: { (UIAlertAction) in
        viewController.navigationController?.popViewController(animated: true)
    }))
    return alert
}

let countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]

func getCountryPhonceCode (_ country : String) -> String?{
    return countryDictionary[country]
}

func getCountryCode (_ pincode : String) -> String?{
    return countryDictionary.first(where: { $1 == pincode })?.key
}

func getCountryList() -> [(name: String, flag: String, code: String)]{
    var countriesData = [(name: String, flag: String, code: String)]()

    for code in NSLocale.isoCountryCodes  {
        
        let flag = String.emojiFlag(for: code)
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])

        if let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id), let zipCode = getCountryPhonceCode(code){
            countriesData.append((name: name, flag: flag!, code: zipCode))
        }
        
    }
    return countriesData
}

func getDateInString(timeStamp: Int64) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm a"
    return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval((timeStamp)/1000)))
}
