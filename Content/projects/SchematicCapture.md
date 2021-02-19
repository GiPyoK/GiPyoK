---
date: 2020-03-02 10:10
description: iOS/web app for capturing and annotating photos of manufacturing machinery
tags: SchematicCapture, Swift, iOS, UIKit, Firebase, CoreData, PencilKit, PDFKit, collab
excerpt: Schematic Capture 
---
# Schematic Capture <a href="https://github.com/Lambda-School-Labs/schematic-capture-ios" target="_blank"><i class="fab fa-github" style="font-size: 1em;"></i></a>
 
 <img src="/images/Schematic Capture/Schematic Capture mockup.png" alt="Schematic Capture iPhone" class="responsive" width="720" />
 
<video class="responsive" width="360" controls>
    <source src="/videos/Schematic Capture Demo.mp4" type="video/mp4">
    Schematic Capture Demo Video
</video>


Schematic Capture is an iOS/web app for capturing and annotating photos of manufacturing machinery. The web app is responsible for assigning jobs and providing appropriate job-sheets to field technicians. The iOS app is responsible for the field technicians to download assigned job-sheets, take photos, and annotate them.

This project was built with 4 web developers, 1 UX designer, and 1 iOS developer.

- **Swift**
- **REST API**
- **Firebase Authentication -** Provide secure user authentication with email or Google account
- **Firebase Storage -** Upload and store job sheets (CSV), schematics (PDF), and photos (PNG)
- **CoreData** - Persist projects for offline capability
- **PencilKit** - Annotated captured photos
- **PDFKit** - Provided an easy mechanism to view schematics
- **SCLAlertView** - Provided simple alter views for success and warning messages
- **ExpyTableView** - Enabled expandable table view
