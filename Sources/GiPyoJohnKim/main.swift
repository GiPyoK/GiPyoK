import Foundation
import Publish
import Plot
import SplashPublishPlugin


// This type acts as the configuration for your website.
struct GiPyoJohnKim: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case about
        case projects
        case blog
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://gipyok.github.io/GiPyoK/")!
    var name = "Gi Pyo John Kim's Portfolio"
    var description = "Gi Pyo John Kim - My development journey"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

//try GiPyoJohnKim().publish(using: [.installPlugin(.splash(withClassPrefix: "")),
//                                   .copyResources(),
//                                   .addMarkdownFiles(at: "Content"),
//                                   .sortItems(by: \.date),
//                                   .generateHTML(withTheme: .foundation),
//                                   .generateSiteMap()])

try GiPyoJohnKim().publish(withTheme: .myTheme,
                           deployedUsing: .gitHub("GiPyoK/GiPyoK"),
                           plugins: [.splash(withClassPrefix: "")]
)
