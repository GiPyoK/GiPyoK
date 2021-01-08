//
//  File.swift
//  
//
//  Created by Gi Pyo Kim on 1/7/21.
//

import Publish
import Plot

extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHtmlFactory(),
            resourcePaths: ["Resources/Theme/styles.css"]
        )
    }
}
