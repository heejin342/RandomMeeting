//
//  RandomUserResponse.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/10.
//

import Foundation


struct RandomUserResponse: Decodable{
    
    var results: [results]
    var info: info
    
}

struct results: Decodable{
    
    var gender: String
    var name: name
    var location: location

    var email: String
    var login: login
    var dob: dob
    var registered: registered
    var phone: String
    var cell: String
//    var id: id
    var picture: picture
    var nat: String

    
}

struct name: Decodable{
    
    var title: String
    var first: String
    var last: String
 
}

struct location: Decodable{
    
    var street: street
    var city: String
    var state: String
    var country: String
    var postcode: Int
    var coordinates: coordinates
    var timezone: timezone

}


struct street: Decodable{
    
    var number: Int
    var name: String

}


struct coordinates: Decodable{
    
    var latitude: String
    var longitude: String

}


struct timezone: Decodable{
    
    var offset: String
    var description: String

}



struct login: Decodable{
    
    var uuid: String
    var username: String
    var password: String
    var salt: String
    var md5: String
    var sha1: String
    var sha256: String
}

    
struct dob: Decodable{
    
    var date: String
    var age: Int

}

struct registered: Decodable{
    
    var date: String
    var age: Int

}

//struct id: Decodable{
//    
//    var name: String
//    var value: String
//
//}

struct picture: Decodable{
    
    var large: String
    var medium: String
    var thumbnail: String

}

struct info: Decodable{
    
    var seed: String
    var results: Int
    var page: Int
    var version: String
}

