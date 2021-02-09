//
//  TageList.swift
//  
//
//  Created by Gi Pyo Kim on 2/4/21.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func tagList(for tags: [Tag], on site: GiPyoJohnKim) -> Node {
        return .div(.class("post-tags"), .forEach(tags) { tag in
            .a(
                .class("post-category post-category-\(tag.string.lowercased())"),
                .href(site.path(for: tag)),
                .text(tag.string)
            )
        })
    }
    
    static func tagList(for item: Item<GiPyoJohnKim>, on site: GiPyoJohnKim) -> Node {
        return .tagList(for: item.tags, on: site)
        
    }
    
    static func tagList(for page: TagListPage, on site: GiPyoJohnKim) -> Node {
        return .tagList(for: Array(page.tags), on: site)
    }
}
