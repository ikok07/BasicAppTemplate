//
//  ListInputField.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 17.12.23.
//

import SwiftUI

struct ListInputField: View {
    
    @FocusState private var focusState: Bool
    @StateObject var viewModel: TextFieldViewModel = TextFieldViewModel()
    
    var icon: String? = nil
    let label: String?
    let placeholder: String
    var isDisabled: Bool = false
    @Binding var resetter: Bool
    @Binding var text: String
    
    var labelWidth: CGFloat = 50
    
    var iconColor: Color = Color.accentColor
    var iconFont: Font = .title2
    
    var keyboardType: UIKeyboardType = .default
    var autoCapitalisation: Bool = true
    var secureField: Bool = false
    var validationType: TextFieldValidationType = .none
    var showErrorText: Bool = false
    
    var textToCompare: String? = nil
    
    @Binding var validation: Bool
    
    init(icon: String? = nil, label: String?, placeholder: String, isDisabled: Bool = false, resetter: Binding<Bool> = .constant(false), text: Binding<String>, textToCompare: String? = nil, validation: Binding<Bool> = .constant(false)) {
        self.icon = icon
        self.label = label
        self.placeholder = placeholder
        self.isDisabled = isDisabled
        self.textToCompare = textToCompare
        
        _resetter = resetter
        _text = text
        _validation = validation
    }
    
    func labelWidthSize(_ value: CGFloat) -> ListInputField {
        var view = self
        view.labelWidth = value
        return view
    }
    
    func customIcon(color: Color = Color.accentColor, font: Font = .title2) -> ListInputField {
        var view = self
        view.iconColor = color
        view.iconFont = font
        return view
    }
    
    func validationType(_ type: TextFieldValidationType) -> ListInputField {
        var view = self
        view.validationType = type
        
        if case .password = type {
            view.secureField = true
        } else if case .confirmPassword(let mainPassword, _) = type {
            view.secureField = true
            view.textToCompare = mainPassword
        }
        
        return view
    }
    
    // It also disabled auto capitalisation
    func isSecure() -> ListInputField {
        var view = self
        view.secureField = true
        view.autoCapitalisation = false
        return view
    }
    
    func disableCapitalisation() -> ListInputField {
        var view = self
        view.autoCapitalisation = false
        return view
    }
    
    func keyboardType(_ type: UIKeyboardType) -> ListInputField {
        var view = self
        view.keyboardType = type
        return view
    }
    
    var body: some View {
        HStack(spacing: 25) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(viewModel.textFieldError.isAvailable ? .red : iconColor)
                        .font(iconFont)
                }
                if let label {
                    Text(label)
                        .foregroundStyle(viewModel.textFieldError.isAvailable ? .red : .label)
                }
            }
            .frame(width: labelWidth)
            
            VStack(alignment: .leading, content: {
                if secureField {
                    SecureField(placeholder, text: $text)
                        .disabled(isDisabled)
                        .keyboardType(keyboardType)
                        .focused($focusState)
                        .textInputAutocapitalization(autoCapitalisation ? .sentences : .never)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundStyle(isDisabled ? Color(uiColor: .tertiaryLabel) : Color(uiColor: .label))
                        .disabled(isDisabled)
                        .keyboardType(keyboardType)
                        .focused($focusState)
                        .textInputAutocapitalization(autoCapitalisation ? .sentences : .never)
                }
                
                if viewModel.textFieldError.isAvailable && self.showErrorText {
                    Text(viewModel.textFieldError.text)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            })
        }
        .onAppear {
            viewModel.validationType = self.validationType
        }
        .onChange(of: self.text) { _, newText in
            performValidation(text: newText)
        }
        .onChange(of: self.resetter, { oldValue, newValue in
            viewModel.textFieldError.isAvailable = false
        })
        .onChange(of: self.textToCompare, { oldValue, newValue in
            if newValue != nil, !self.text.isEmpty {
                performValidation(text: self.text)
            }
        })
        .animation(.default, value: viewModel.textFieldError.isAvailable)
        .animation(.default, value: self.text)
        .animation(.default, value: viewModel.textFieldError.text)
    }
    
    func performValidation(text: String) {
        viewModel.validationType = self.validationType
        viewModel.validate(text: text)
        validation = !viewModel.textFieldError.isAvailable
    }
}

#Preview {
    List {
        ListInputField(label: "Email", placeholder: "Your email", isDisabled: true, text: .constant("kokmarok@gmail.com"), validation: .constant(false))
    }
}
