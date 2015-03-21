//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Amund Tveit on 21/03/15.
//  Copyright (c) 2015 Amund Tveit. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(fromFilePathURL filePathUrl:NSURL, fromTitle title:String) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}