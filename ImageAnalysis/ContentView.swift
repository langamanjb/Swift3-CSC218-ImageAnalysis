import SwiftUI
import Vision

struct ContentView: View {

    @State private var categoriesList: String = "Loading..."

    var body: some View {

        VStack {

            Image("animals2")
                .resizable()
                .scaledToFit()
                .padding()

            Text(categoriesList)

            Spacer()
        }
        .padding()
        .task {
            guard let uiImage = UIImage(named: "animals2"),
                  let cgImage = uiImage.cgImage else {
                categoriesList = "Image not found or cannot convert to CGImage!"
                return
            }

            do {
                let request = ClassifyImageRequest()
                var results = try await request.perform(on: cgImage)
                
                results = results.filter {
                    $0.hasMinimumPrecision(0.2, forRecall: 0.9) && $0.confidence > 0.2
                }

                categoriesList = results.isEmpty
                    ? "No categories found"
                    : results.map(\.identifier).joined(separator: ", ")

            } catch {
                categoriesList = "Error: \(error)"
                print(error)
            }
        }
    }
}
