//
//  Grid.swift
//  
//
//  Created by Gi Pyo Kim on 2/4/21.
//

import Plot

extension Node where Context == HTML.BodyContext {
    static func grid(_ nodes: Node...) -> Node {
        .div(
            .id("layout"),
            .class("pure-g"),
            .group(nodes)
        )
    }
}
