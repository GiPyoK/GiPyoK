---
date: 2021-01-07 10:34
description: Getting started with Publish by John Sundell to create my own portfolio website with Swift
tags: Publish, Swift
excerpt: Creating Portfolio with Publish by John Sundell
---
# Creating Portfolio with Publish by John Sundell

I first built my portfolio website with basic HTML and CSS. It was my first attempt at creating a website and it looked ugly. While I was browsing through various libraries to enhance the look and maintainability of my portfolio, I stumbled upon a library called [Publish](https://github.com/JohnSundell/Publish) by John Sundell. Publish is a static site generator built for Swift developers. I thought this would be a good tool to make my portfolio website and be a fun challenge to learn about it.

### Getting started

```
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
$ mkdir GiPyoJohnKim
$ cd GiPyoJohnKim
$ publish new
```

After running these lines of code in the terminal, I was ready to create my website.

### Basic setup

Inside `main.swift` file, I added my own section id's.

```swift
enum SectionID: String, WebsiteSectionID {
    case about
    case projects
    case blog
}
```



The section id's will play the role of a navigation bar.

Next is the theme. There was the Foundation theme already available, but I wanted the option to modify the theme if needed. So, I duplicated `styles.css` file under `Publish/Resources/FoundationTheme/` into my Resources folder and created a new `HTMLFactory`.

```
struct MyHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML("Hello World!")
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
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
```

Then, I grabbed `wrapper`, `itemList`, and `tagList` from Foundation theme and will make modifications later.

```swift
private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }
}
```

With my own `styles.css`  file and  `HTMLFactory` defined, I can now initialized my own theme.

```swift
 extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHtmlFactory(),
            resourcePaths: ["Resources/Theme/styles.css"]
        )
    }
}
```

Lastly, I can apply my theme and publish my website using this line of code:

```swift
try GiPyoJohnKim().publish(withTheme: .myTheme)
```

### Formatting the page

Right now, the main page only shows "Hello World!" because there is nothing but `HTML("Hello World!")` inside `makeIndexHTML()`function. Whatever that goes inside the `makeIndexHTML()` function will show in the main home page. I formatted the page so that it will show my dummy blog posts and projects. (This is just a test to see if I can populate the site with given markdown files. I will change the looks of the main page later.)

```swift
func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            
            .body(
                .myHeader(for: context),
                
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
```

The`.head` tag will display the name of the site, and the `.body` tag will loop through all the items in the content folder and display them in a list.

This is my folder structure:

<img src="/images/Portfolio/Untitled.png" alt="0" />

This is how the dummy markdown file is formatted:

<img class="responsive" src="/images/Portfolio/Untitled 1.png" alt="1" width="720" />

This is how the actual site looks like:

<img class="responsive" src="/images/Portfolio/Untitled 2.png" alt="2" width="720" />

When I was playing around with the Foundation theme, I remembered that there were section names below the site name. I found `.header` tag already defined in `Theme+Foundation.swift` file and replaced my `.myHeader` with it.

```swift
.body(
		.header(for: context, selectedSection: (GiPyoJohnKim.SectionID.about as! Site.SectionID)),
		// ...
)
```

Although the main page shows a list of blog posts and project posts, I will change the main page to be the about page. So I highlighted the about section, and this is how the main page:

<img class="responsive" src="/images/Portfolio/Untitled 3.png" alt="3" width="720" />

Right now, a blank page shows up when the title of a post is clicked. By implementing `makeItemHTML()` function, the blank page will be replaced with the actual content of the post.

```swift
func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            
            .body(
                .header(for: context, selectedSection: item.sectionID),
                
                .wrapper(
                    .article(
                        .class("content"),
                        .tagList(for: item, on: context.site),
                        .contentBody(item.body)
                    ) //article
                ) //wrapper
            ) //body
        ) //html
    }
```

<img class="responsive" src="/images/Portfolio/Untitled 4.png" alt="4" width="720" />
