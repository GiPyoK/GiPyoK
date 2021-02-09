//
//  Footer.swift
//  
//
//  Created by Gi Pyo Kim on 2/8/21.
//

import Plot

extension Node where Context == HTML.BodyContext {
    static func footer(for site: GiPyoJohnKim) -> Node {
        return .div(
            .class("footer pure-u-1"),
            .div(
                .class("pure-u-1"),
                .text("© 2021 \(site.name)")
            ),
            .div(
                .class("pure-u-1"),
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                ),
                .text(". Written in Swift")
            )
        )
    }
}
