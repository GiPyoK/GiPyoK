//
//  Post.swift
//  
//
//  Created by Gi Pyo Kim on 2/8/21.
//
import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func post(for item: Item<GiPyoJohnKim>, on site: GiPyoJohnKim) -> Node {
        return .pageContent(
            .h2(
                .class("post-title"),
                .a(
                    .href(item.path),
                    .text(item.title)
                )
            ),
            .p(
                .class("post-meta"),
                .text(DateFormatter.blog.string(from: item.date))
            ),
            .tagList(for: item, on: site),
            .div(
                .class("post-description"),
                .div(
                    .contentBody(item.body)
                )
            )
        )
    }
}

