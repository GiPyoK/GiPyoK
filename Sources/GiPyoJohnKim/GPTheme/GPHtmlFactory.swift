//
//  GPHtmlFactory.swift
//  
//
//  Created by Gi Pyo Kim on 1/7/21.
//

import Publish
import Plot

struct GPHtmlFactory: HTMLFactory {
    
    // Homepage - shows recents posts (blog and projects)
    func makeIndexHTML(for index: Index, context: PublishingContext<GiPyoJohnKim>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context),
                    .sidebar(for: context.site),
                    .posts(for: context.allItems (sortedBy: \.date, order: .descending),
                           on: context.site,
                           title: "Recent posts"),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    // Section - shows list of posts on each section
    func makeSectionHTML(for section: Section<GiPyoJohnKim>, context: PublishingContext<GiPyoJohnKim>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context),
                    .sidebar(for: context.site),
                    .posts(for: section.items,
                           on: context.site,
                           title: section.title),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    // Post - shows the content of a single post
    func makeItemHTML(for item: Item<GiPyoJohnKim>, context: PublishingContext<GiPyoJohnKim>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context),
                    .sidebar(for: context.site),
                    .post(for: item, on: context.site),
                    .footer(for: context.site)
                )
                
            )
        )
    }
    // Page - shows about page
    func makePageHTML(for page: Page, context: PublishingContext<GiPyoJohnKim>) throws -> HTML {
        HTML(
           .lang(context.site.language),
           .head(for: context.site),
           .body(
               .grid(
                   .header(for: context),
                   .sidebar(for: context.site),
                   .page(for: page, on: context.site),
                   .footer(for: context.site)
               )
           )
       )
    }
    
    // List of all tags in the website
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<GiPyoJohnKim>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for :context.site),
            .body(
                .grid(
                    .header(for: context),
                    .sidebar(for: context.site),
                    .h1(.class("content pure-u-1 pure-u-md-3-5 pure-u-xl-6-10 posts content-subhead"), .text("All Tags")),
                    .pageContent(
                        .tagList(for: page, on: context.site)
                    ),
                     .footer(for: context.site)
                )
            )
        )
    }
    
    // List of posts that has matching tags
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<GiPyoJohnKim>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context),
                    .sidebar(for: context.site),
                    .pageContent(
                        .div(
                            .class("posts"),
                            .h1(.class("content-subhead"), .text("\(page.tag.string.capitalized) posts")),
                            .a(
                                .class("post-category all-tags"),
                               .href(context.site.tagListPath),
                               .text("View all tags")
                            ),
                            .forEach(context.items(taggedWith: page.tag, sortedBy: \.date, order: .descending)) { item in
                                .postExcerpt(for: item, on: context.site)
                            }
                        )
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    
}

