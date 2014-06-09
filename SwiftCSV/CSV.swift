//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

class CSV {
    let headers: String[]?
    
    init(contentsOfURL url: NSURL) {
        let csvString = String.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: nil)
        let lines = csvString?.componentsSeparatedByString("\n")
        self.headers = lines?[0].componentsSeparatedByString(",")
    }
}
