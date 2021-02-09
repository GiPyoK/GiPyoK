//
//  Wrapper.swift
//  
//
//  Created by Gi Pyo Kim on 2/4/21.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
}
