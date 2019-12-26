//
//  quanta.swift
//  Inkz
//
//  Created by Chuck Deerinck on 12/24/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit

func quanta(_ num:CGFloat = CGFloat.random(in: 0...1), by: Int=6) -> CGFloat {
    return CGFloat(floor(num * CGFloat(by)) / CGFloat(by))
}
