//
//  Header.swift
//  
//
//  Created by Gi Pyo Kim on 1/7/21.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func header(for context: PublishingContext<GiPyoJohnKim>) -> Node {
        let sectionIDs = GiPyoJohnKim.SectionID.allCases
        return .div(
            .div(
                .class("pure-menu pure-menu-horizontal pure-u-1-1 top-header"),
                .a(
                    .class("pure-menu-heading"),
                    .text(context.site.name),
                    .href("/")
                ),
                .ul(
                    .class("pure-menu-list"),
                    .forEach(sectionIDs) { section in
                       .li(
                           .class("pure-menu-item"),
                           .a(
                               .class("pure-menu-link"),
                               .href(context.sections[section].path),
                               .text(context.sections[section].title)
                           )
                       )
                    }
                )
            )
        )
    }
}

