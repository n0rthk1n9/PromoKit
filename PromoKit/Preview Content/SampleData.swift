//
//  SampleData.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import Foundation

struct SampleData {
    static var promoApps: [PromoApp] = [
        promoApp1,
        promoApp2
    ]
    
    static var promoApp1 = PromoApp(
        name: "App Exhibit",
        version: "1.3",
        appId: "6503256642",
        promoCodes: []
    )
    
    static var promoApp2 = PromoApp(
        name: "Cosmo Pic",
        version: "1.0",
        appId: "129381232",
        promoCodes: []
    )
    
    static var promoCodesPromoApp1: [PromoCode] = [
        promoCode1PromoApp1,
        promoCode2PromoApp1,
        promoCode3PromoApp1
    ]
    
    static var promoCode1PromoApp1 = PromoCode(
        code: "AF4HYL4EETAP",
        dateAdded: .now,
        used: false,
        promoApp: promoApp1
    )
    
    static var promoCode2PromoApp1 = PromoCode(
        code: "NTYEJLYFHYJT",
        dateAdded: .now,
        used: true,
        promoApp: promoApp1
    )
    
    static var promoCode3PromoApp1 = PromoCode(
        code: "7HMHWLA6A9JM",
        dateAdded: .now,
        used: false,
        promoApp: promoApp1
    )
}
