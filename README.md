@State private var name = ""
@State private var description = ""
@State private var selectedCity = ""
@State private var showError = false

var body: some View {
    VStack(spacing: 24) {
        FloatingInputField(
            text: $name,
            placeholder: "Name",
            inputType: .singleLine,
            dropdownOptions: [],
            message: "Name is required",
            showMessage: showError && name.isEmpty
        )

        FloatingInputField(
            text: $description,
            placeholder: "Description",
            inputType: .multiLine,
            dropdownOptions: [],
            message: "Description too short",
            showMessage: showError && description.count < 5
        )

        FloatingInputField(
            text: $selectedCity,
            placeholder: "Select a city",
            inputType: .dropdown,
            dropdownOptions: ["New York", "London", "Tokyo"],
            message: "City is required",
            showMessage: showError && selectedCity.isEmpty
        )

        Button("Submit") {
            showError = true
        }
    }
    .padding()
}

Use FloatingInputField in your form
@State private var name = ""
@State private var description = ""
@State private var selectedCity = ""
@State private var showError = false

var body: some View {
    VStack(spacing: 24) {
        FloatingInputField(
            text: $name,
            placeholder: "Name",
            inputType: .singleLine,
            dropdownOptions: [],
            message: "Name is required",
            showMessage: showError && name.isEmpty
        )

        FloatingInputField(
            text: $description,
            placeholder: "Description",
            inputType: .multiLine,
            dropdownOptions: [],
            message: "Description too short",
            showMessage: showError && description.count < 5
        )

        FloatingInputField(
            text: $selectedCity,
            placeholder: "Select a city",
            inputType: .dropdown,
            dropdownOptions: ["New York", "London", "Tokyo"],
            message: "City is required",
            showMessage: showError && selectedCity.isEmpty
        )

        Button("Submit") {
            showError = true
        }
    }
    .padding()
}

Parameter | Type | Description
text | Binding<String> | Bound input value
placeholder | String | Label shown as floating placeholder
inputType | InputType | Choose between .singleLine, .multiLine, .dropdown
dropdownOptions | [String] | List of options for .dropdown input type
message | String? | Optional validation or helper message
showMessage | Bool | Controls whether the message is visible
