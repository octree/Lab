import SwiftUI
import NaturalLanguage

class DiffPlaygroundModel: ObservableObject {
    @Published var origin: String = ""
    @Published var bob: String = ""
    @Published var alice: String = ""
    var text: AttributedString {
        diff.map { $0.attributedString }
            .reduce(AttributedString(), +)
    }

    var diff: [Diff<String>] {
        Myers(origin.lines, bob.lines).diff()
    }
}

struct DiffPlayground: View {
    @StateObject var viewModel = DiffPlaygroundModel()
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading) {
                Text("Origin").padding(.leading).font(.callout).foregroundColor(Color(white: 0.7))
                TextEditor(text: $viewModel.origin)
                Divider()
                Text("Bob").padding(.leading).font(.callout).foregroundColor(Color(white: 0.7))
                TextEditor(text: $viewModel.bob)
            }
            .padding(.top, 1)
            Divider()
            VStack(alignment: .leading) {
                Text("Alice").padding(.leading).font(.callout).foregroundColor(Color(white: 0.7))
                TextEditor(text: $viewModel.alice)
                Divider()
                Text("Result").padding(.leading).font(.callout).foregroundColor(Color(white: 0.7))
                ScrollView {
                    VStack {
                        Text(viewModel.text)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .font(.system(size: 16))
    }
}

extension String {
    var words: [Substring] {
        let tagger = NaturalLanguage.NLTagger(tagSchemes: [.tokenType])
        tagger.string = self
        var result = [Substring]()
        tagger.enumerateTags(in: startIndex ..< endIndex,
                             unit: .word,
                             scheme: .tokenType,
                             options: [.joinNames]) { _, range in
            result.append(self[range])
            return true
        }
        return result
    }
}

extension Diff where T: CustomStringConvertible {
    var attributedString: AttributedString {
        var text = AttributedString(value.description + "\n")
        switch type {
        case .delete:
            text.foregroundColor = .red
            text.backgroundColor = .red.opacity(0.1)
            text.strikethroughStyle = .single
            text.strikethroughColor = .red
        case .insert:
            text.foregroundColor = .green
            text.backgroundColor = .green.opacity(0.1)
        case .same:
            break
        }
        return text
    }
}


extension String {
    var lines: [String] {
        var lines: [String] = []
        enumerateLines { line, stop in
            lines.append(line)
        }
        return lines
    }
}
