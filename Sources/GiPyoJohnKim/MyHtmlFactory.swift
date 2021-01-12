//
//  File.swift
//  
//
//  Created by Gi Pyo Kim on 1/7/21.
//

import Publish
import Plot

struct MyHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            
            .body(
                .header(for: context, selectedSection: (GiPyoJohnKim.SectionID.about as! Site.SectionID)),
                
                .wrapper(
                    .ul(
                        .class("item-list"),
                        .forEach(context.allItems(sortedBy: \.date, order: .descending)) { item in
                            .li(
                                .article(
                                    .h1(
                                        .a(
                                            .href(item.path),
                                            .text(item.title)
                                        ) //a
                                    ), //h1
                                    .tagList(for: item, on: context.site),
                                    .p(.text(item.description))
                                ) //article
                            ) //li
                        }) //ul
                ) //wrapper
            ) //body
        ) //html
    }
    
    //context.items(taggedWith: "Blog", sortedBy: \.date, order: .descending)
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: section, on: context.site)
        )
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            
            .body(
                .myHeader(for: context),
                
                .wrapper(
                    .article(
                        .contentBody(item.body)
                    ) //article
                ) //wrapper
            ) //body
        ) //html
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}
