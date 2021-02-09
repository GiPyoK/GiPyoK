//
//  Page.swift
//  
//
//  Created by Gi Pyo Kim on 2/8/21.
//

import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func page(for page: Page, on site: GiPyoJohnKim) -> Node {
        return .pageContent(
            .h2(
                .class("post-title"),
                .text(page.title)
            ),
            .div(
                .class("post-description"),
                .div(
                    .contentBody(page.body)
                )
            )
        )
    }
}
