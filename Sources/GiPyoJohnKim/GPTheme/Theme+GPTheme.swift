//
//  File.swift
//  
//
//  Created by Gi Pyo Kim on 1/7/21.
//

import Publish
import Plot

extension Theme where Site == GiPyoJohnKim{
    static var GPTheme: Theme {
        Theme(htmlFactory: GPHtmlFactory())
    }
}
