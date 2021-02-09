//
//  File.swift
//  
//
//  Created by Gi Pyo Kim on 2/4/21.
//

import Foundation

struct SocialMedia {
    let title: String
    let url: String
    let icon: String
}

extension SocialMedia {
    static var location: SocialMedia {
        return SocialMedia(title: "La Habra, California",
                           url: "https://www.google.com/maps/place/La+Habra,+CA+90631/@33.9262421,-117.9828256,13z/data=!3m1!4b1!4m5!3m4!1s0x80c2d5313a8b3d83:0xa81f48a1853026dd!8m2!3d33.9318591!4d-117.946137",
                           icon: "fas fa-map-marker-alt")
    }
    
    static var email: SocialMedia {
        return SocialMedia(title: "Email",
                           url: "mailto:gipyok@gmail.com",
                           icon: "fas fa-envelope")
    }
    
    static var github: SocialMedia {
        return SocialMedia(title: "GitHub",
                           url: "https://github.com/GiPyoK",
                           icon: "fab fa-github-square")
    }
    
    static var linkedIn: SocialMedia {
        return SocialMedia(title: "LinkedIn",
                           url: "https://www.linkedin.com/in/gipyo-john-kim/",
                           icon: "fab fa-linkedin")
    }
    
    static var resume: SocialMedia {
        return SocialMedia(title: "Resumé",
                           url: "/resume.pdf",
                           icon: "fas fa-file")
    }
}
