//
//  ContentView.swift
//  FloatingInputField
//
//  Created by Hardik Darji on 15/04/25.
//

import SwiftUI

// Preview
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}

struct FormView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var city = ""

    @State private var showValidation = false

    var body: some View {
        VStack(spacing: 16) {
            FloatingInputField(
                text: $name,
                placeholder: "Name",
                inputType: .singleLine,
                message: "Name is required",
                showMessage: showValidation && name.isEmpty
            )
            
            FloatingInputField(
                text: $description,
                placeholder: "Description",
                inputType: .multiLine,
                message: "Desc is required",
                showMessage: showValidation && description.isEmpty
            )
            FloatingInputField(
                text: $city,
                placeholder: "City",
                inputType: .dropdown,
                dropdownOptions: ["New York", "London", "Tokyo"],
                message: "Please select a city",
                showMessage: showValidation && city.isEmpty
            )


            
            Button("Submit") {
                showValidation = true
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
    }
}

enum InputType {
    case singleLine
    case multiLine
    case dropdown
}

struct FloatingInputField: View {
    @Binding var text: String
    let placeholder: String
    let inputType: InputType
    var dropdownOptions: [String]  = []

    let message: String?
    let showMessage: Bool

    @FocusState private var isFocused: Bool
    @State private var selectedOption: String = ""
    @State private var isDropdownFocused = false

    private var shouldFloatLabel: Bool {
        isFocused || isDropdownFocused || !text.isEmpty
    }

    private var isDropdownSelected: Bool {
        if case .dropdown = inputType {
            return !text.isEmpty
        }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topLeading) {
                // Border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                    .background(Color.white.cornerRadius(8))
                    .frame(height: (inputType == .multiLine ? 100 : 44))

                // Floating Label
                Text(placeholder)
                    .foregroundColor(shouldFloatLabel ? .accentColor : .gray)
                    .font(.system(size: 14))
                    .padding(.horizontal, 4)
                    .background(Color.white)
                    .padding(.leading, 8)
                    .offset(y: shouldFloatLabel ? -10 : 14)
                    .scaleEffect(shouldFloatLabel ? 0.9 : 1.0, anchor: .leading)
                    .animation(.easeOut(duration: 0.2), value: shouldFloatLabel)

                // Input Field
                Group {
                    switch inputType {
                    case .singleLine:
                        TextField("", text: $text)
                            .focused($isFocused)
                            .padding(.horizontal, 12)
                            .frame(height: 44)
                            .background(Color.clear)

                    case .multiLine:
                        PlainTextEditor(text: $text)
                            .focused($isFocused)
                            .background(Color.clear)
                            .padding(.horizontal, 12)
                            .frame(maxHeight: 90)
                            .padding(.top, 8)

                    case .dropdown:
                        Menu {
                            ForEach(dropdownOptions, id: \.self) { option in
                                Button(option) {
                                    selectedOption = option
                                    text = option
                                    isDropdownFocused = false

                                }
                            }
                        } label: {
                            HStack {
                                Text(text.isEmpty ? placeholder : text)
                                    .foregroundColor(text.isEmpty ? .clear : .primary)
                                    .onTapGesture {
                                        isDropdownFocused = true
                                    }
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 44)
                            .background(Color.clear)
                            
                        }
                    }

                }
            }

            // Optional Message
            if showMessage, let message = message {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showMessage)
            }
        }
    }

    // Reuse your PlainTextEditor
    struct PlainTextEditor: UIViewRepresentable {
        @Binding var text: String
        var isEditable: Bool = true

        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.backgroundColor = .clear
            textView.isScrollEnabled = true
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            textView.delegate = context.coordinator
            textView.isEditable = isEditable
            return textView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UITextViewDelegate {
            var parent: PlainTextEditor

            init(_ parent: PlainTextEditor) {
                self.parent = parent
            }

            func textViewDidChange(_ textView: UITextView) {
                parent.text = textView.text
            }
        }
    }
}
