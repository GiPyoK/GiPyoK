---
date: 2020-03-03 10:10
description: How Core Data was used in Schematic Capture
tags: SchematicCapture, CoreData, JSON, Swift
excerpt: How Core Data was used in Schematic Capture
---
# Schematic Capture: Core Data

Schematic Capture needs to persist projects. A project holds different job sheets; a job sheet holds different components; a component has a corresponding photo of that component.  

For easier understanding of the relationship among the entities, here is the graph view:

<img class="responsive" src="/images/Schematic Capture Core Data/Core Data Graph.png" alt="Core Data Graph" width="720" />

The single arrowhead represents one-to-one relationship, and the double arrowhead represents one-to-many relationship. This was my first time dealing with relationships with core data, but after some struggle, I was able to setup the relationship. 

Referencing the above relationships, I created extensions on core data models with convenience init functions. By doing so, it helps the work flow of decoding and encoding JSON data when downloading and uploading the projects.

```swift
//  Project+Convenience.swift
extension Project {
    var projectRepresentation: ProjectRepresentation? {
        guard let name = name, let client = client else { return nil }
        // Sort the job sheet array by id
        let idDescriptor = NSSortDescriptor(key: "id", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let jobSheetsArr = jobSheets != nil ? (jobSheets!.sortedArray(using: [idDescriptor]) as? [JobSheetRepresentation]) : nil
        return ProjectRepresentation(id: Int(id), name: name, jobSheets: jobSheetsArr, client: client, clientId: Int(clientId))
    }
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        jobSheets: [JobSheet]?,
                                        client: String,
                                        clientId: Int,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.jobSheets = jobSheets != nil ? NSSet(array: jobSheets!) : nil
        self.client = client
        self.clientId = Int32(clientId)
    }
    
    @discardableResult convenience init(projectRepresentation: ProjectRepresentation, context: NSManagedObjectContext) {
        
        let jobSheets = projectRepresentation.jobSheets != nil ? projectRepresentation.jobSheets!.map { JobSheet(jobSheetRepresentation: $0, context: context) } : nil
        
        self.init (id: projectRepresentation.id,
            name: projectRepresentation.name,
            jobSheets: jobSheets,
            client: projectRepresentation.client,
            clientId: projectRepresentation.clientId,
            context: context)
    }
}
```

By using `convenience init()`, it makes easy to convert between the actual core data model and the representation of that model.

I made the representation model like so:

```swift
//  ProjectRepresentation.swift
struct ProjectRepresentation: Codable {
    let id: Int
    var name: String
    var jobSheets: [JobSheetRepresentation]?
    let client: String
    let clientId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case jobSheets = "jobsheet"
        case client = "companyName"
        case clientId
    }
}
```

When the app is launched, core data model or the JSON data is converted to the representation model and used throughout the app. Displaying the data and updating the data is handled with the representation model. When uploading the data, representation model is converted into a JSON model and uploaded to our firebase storage. When persisting the data with core data, the representation model is converted back to core data model and saved in a user's phone storage.

Convenience initializers and representation models are made in similar  manner for other entities as well.

An example of representation model being used is when downloading project and decoding the data.

```swift
//  ProjectController.swift
class ProjectController {
    
    var bearer: Bearer?
    var user: User?
    var projects: [ProjectRepresentation] = []

		private let baseURL = URL(string: "https://sc-test-be.herokuapp.com/api")!

		func downloadAssignedJobs(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        
        guard let bearer = self.bearer else {
            completion(.noBearer)
            return
        }
        
        let requestURL = self.baseURL.appendingPathComponent("jobsheets").appendingPathComponent("assigned")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.idToken)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Errer getting assigned jobs: \(error)")
                completion(.serverError(error))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            // decode projects
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let projectsRep = try decoder.decode([ProjectRepresentation].self, from: data)
                
                self.updateProjects(with: projectsRep)
                self.projects = projectsRep
                self.projects.sort { $0.id < $1.id }
                print("\n\nPROJECTS: \(self.projects)\n\n")
            } catch {
                print("Error decoding the jobs: \(error)")
                completion(.badDecode)
            }
            
            completion(nil)
        }.resume()
    }
}

```

Because `CodingKeys` are already defined in the representation model, `JSONDecoder` can easily decode the data into the representation model. Saving the representation model in the core data can also be done easily with convenience initializer, you just have to pass in the representation model and you have the core data model ready to be saved.
