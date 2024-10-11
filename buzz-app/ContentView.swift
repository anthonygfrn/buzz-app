import PDFKit
import SwiftUI

// Create a wrapper for NSTextView to use as a Rich Text Editor
struct RichTextEditor: NSViewRepresentable {
    @Binding var text: NSAttributedString

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        
        // Disable text modification (deletion/removal)
        textView.allowsUndo = false
        textView.textStorage?.setAttributedString(text)
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(text)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
        // Restricting deletion and removal
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            if let replacementString = replacementString, replacementString.isEmpty {
                // Prevent deletion by returning false if replacementString is empty (delete action)
                return false
            }
            return true
        }
        
        // Update the binding when style changes occur
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.attributedString()
        }
    }
}

struct ContentView: View {
    @State private var extractedText = NSAttributedString(string: "The text from the PDF will appear here.")
    
    var body: some View {
        VStack {
            ScrollView {
                RichTextEditor(text: $extractedText)
                    .frame(height: 300)
                    .padding()
            }
            
            Button(action: {
                openPDFPicker()
            }) {
                Text("Select PDF from Finder")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    // Function to open PDF from Finder
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                if let text = convertPDFToAttributedString(from: url) {
                    extractedText = text
                } else {
                    extractedText = NSAttributedString(string: "Failed to extract text from PDF.")
                }
            } else {
                extractedText = NSAttributedString(string: "PDF file not found.")
            }
        }
    }
    
    // Function to convert PDF to NSAttributedString
    func convertPDFToAttributedString(from url: URL) -> NSAttributedString? {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Cannot load PDF file.")
            return nil
        }
        
        let fullText = NSMutableAttributedString()
        for pageIndex in 0 ..< pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string
            {
                let attributedPageText = NSAttributedString(string: pageText + "\n")
                fullText.append(attributedPageText)
            }
        }
        
        return fullText
    }
}

#Preview {
    ContentView()
}
