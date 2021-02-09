//
//  Sidebar.swift
//  
//
//  Created by Gi Pyo Kim on 2/4/21.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func sidebar(for site: GiPyoJohnKim) -> Node {
        return .div(
            .class("sidebar pure-u-1 pure-u-md-1-4"),
            .div(
                .class("header"),
                .grid(
                    .class("pure-u-md-1-1 pure-u-1-4"),
                    .class("author__avatar"),
                    .img(
                        .src("https://avatars.githubusercontent.com/u/18320084?s=400&u=92a1ad581ff45b1f9107f616068011562b3be323&v=4")
                    ),
                    .div(
                        .class("pure-u-md-1-1 pure-u-3-4"),
                        .h1(
                            .class("brand-title"),
                            .text(site.name)
                        ),
                        .h3(
                            .class("brand-tagline"),
                            .text(site.description)
                        )
                    )
                ),
                .grid(
                    .forEach(site.socialMedia, { link in
                        .div(
                            .class("pure-u-md-1-1"),
                            .a(
                                .href(link.url),
                                .icon(link.icon),
                                .a(
                                    .class("social-media"),
                                    .href(link.url),
                                    .text(link.title)
                                )
                            )
                        )
                    })
                )
            )
        )
    }
}
