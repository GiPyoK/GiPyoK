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
        var excerpt: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://www.gipyo-john-kim.com")!
    var name = "Gi Pyo John Kim"
    var description = "iOS Developer"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMedia: [SocialMedia] = [.location, .email, .github, .linkedIn, .resume]
}

try GiPyoJohnKim().publish(withTheme: .GPTheme,
                           deployedUsing: .gitHub("GiPyoK/GiPyoJohnKim", useSSH: false),
                           plugins: [.splash(withClassPrefix: "")]
)
