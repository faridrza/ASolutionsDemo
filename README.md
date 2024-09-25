# ASolution Demo App

Welcome to the **ASolution Demo App**, a sample iOS application developed as a demonstration project for ASolution company by **Farid Rzayev**. This app showcases a simple banking interface where users can create an account, manage debit cards, and transfer funds between cards.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)
- [Input Validation and Error Handling](#input-validation-and-error-handling)
- [Formatting and User Experience](#formatting-and-user-experience)
- [Bug Prevention Measures](#bug-prevention-measures)
- [Contact](#contact)

## Features

- **Account Creation**: Users can create a new account by providing their name, surname, birthdate, and phone number.
  - **Birthdate Selection**: The birthdate field uses a date picker to ensure accurate date selection.
  - **Phone Number Validation**: The phone number field is formatted and validated to accept only valid numbers, preventing incorrect input.
- **Debit Card Management**:
  - **Add Cards**: Users can add new debit cards by entering a 16-digit card number.
    - **Card Number Formatting**: As users input the card number, it is automatically formatted for better readability.
    - **Input Restriction**: Only digits are allowed; any other characters are prevented.
    - **Duplicate Prevention**: The app checks for existing card numbers to prevent adding duplicate cards.
  - **Delete Cards**:
    - **Reason Selection**: When deleting a card, users are prompted to select a reason for deletion from predefined options.
- **Fund Transfer**:
  - **Between Cards**: Transfer funds between the user's own cards.
    - **Receiver Card Selection**: Users can select the receiver card from a picker with a toolbar containing a **Done** button for confirmation.
    - **Transfer Amount Input**: Users can input the transfer amount, which is limited to two decimal places.
  - **Validation**: Ensures sufficient balance and correct input before processing the transfer.

## Screenshots

### Account Creation
<img src="https://github.com/user-attachments/assets/bd76f2fd-a410-4171-8181-4ec99f0fd141" alt="Account Creation Screen" width="200"/>


### Card List

<img src="https://github.com/user-attachments/assets/e14881d8-d1dd-4dbe-8e91-709129a5e745" alt="Account Creation Screen" width="200"/>

### Transfer Funds

<img src="https://github.com/user-attachments/assets/e082256e-2def-4645-a0f3-1c82104b00ee" alt="Account Creation Screen" width="200"/>

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/asolution-demo-app.git
   ```

2. **Open the Project**

   - Navigate to the cloned directory.
   - Open `ASolutionDemoApp.xcworkspace` with Xcode.

3. **Build and Run**

   - Select the desired simulator or your iOS device.
   - Click on the **Run** button or press `Cmd + R`.

## Usage

### 1. Create an Account

- **Fill in Personal Details**:
  - **Name and Surname**: Enter your first and last name.
  - **Birthdate**: Tap the birthdate field to open the date picker and select your birthdate. Manual input is disabled to prevent incorrect dates.
  - **Phone Number**: The field is pre-filled with the country code "+994". Enter the remaining digits of your phone number. The app prevents entering more digits than allowed and restricts input to numbers only.
- **Validation**:
  - The **Create Account** button remains disabled until all fields are correctly filled.
  - Real-time validation ensures all inputs meet the required format and constraints.

### 2. Manage Debit Cards

- **Access Card List**: Navigate to the **Card List** from the dashboard.
- **Add a New Card**:
  - Tap the **Add** button.
  - **Card Number Input**:
    - Enter a 16-digit card number.
    - Only numeric input is accepted; other characters are prevented.
    - The card number is automatically formatted for readability (e.g., "1234 5678 9012 3456").
    - Input is restricted to 16 digits.
  - **Validation**:
    - The app checks for duplicates to prevent adding the same card twice.
    - If the card number is invalid or already exists, an appropriate error message is displayed.
- **Delete a Card**:
  - Swipe left on a card to reveal the **Delete** option.
  - **Reason Selection**:
    - An action sheet appears prompting you to select a reason for deletion (e.g., Lost Card, Stolen Card, Damaged Card, No Longer Needed, Other).
    - If 'Other' is selected, you can provide a custom reason.
  - **Confirmation**:
    - After selecting a reason, the card is deleted, and a success message is displayed.

### 3. Transfer Funds

- **Initiate Transfer**:
  - Tap the **Transfer** button on the card you wish to transfer funds from.
  - **Note**: If you have only one card, a warning message informs you that no other cards are available to transfer to.
- **Select Receiver Card**:
  - A picker allows you to select the receiver card.
  - The picker includes a toolbar with a **Done** button to confirm your selection.
- **Enter Transfer Amount**:
  - Input the amount you wish to transfer.
  - **Amount Restrictions**:
    - Only numbers are accepted.
    - Input is limited to two decimal places.
    - The app prevents entering an amount exceeding the sender card's balance.
- **Complete Transfer**:
  - Tap the **Transfer** button.
  - The app validates all inputs and processes the transfer.
  - A confirmation message is displayed upon successful transfer.

## Input Validation and Error Handling

- **Real-Time Validation**:
  - The app validates user inputs in real-time, providing immediate feedback.
- **Name and Surname**:
  - Must not be empty.
- **Birthdate**:
  - Selection is enforced through the date picker; manual entry is disabled.
- **Phone Number**:
  - Only numeric input is accepted after the "+994" prefix.
  - Input is limited to the required number of digits.
  - The app prevents deletion or alteration of the country code.
- **Card Number**:
  - Only digits are accepted.
  - Input is limited to 16 digits.
  - Automatic formatting enhances readability.
  - Duplicate cards are not allowed.
- **Transfer Amount**:
  - Only numeric input is accepted.
  - Limited to two decimal places.
  - Amount must not exceed the sender card's balance.
  - Empty or invalid inputs are rejected.

- **Error Messages**:
  - Clear and descriptive error messages guide users to correct their inputs.
  - Messages are displayed using alerts or inline feedback.

## Formatting and User Experience

- **Input Fields**:
  - Custom input fields enhance the user experience with clear labels and placeholders.
  - Padding and styling are applied for better aesthetics.
- **Date Picker**:
  - Birthdate selection uses a date picker with a toolbar containing a **Done** button.
  - The toolbar enhances usability by allowing users to confirm their selection.
- **Picker Views**:
  - Receiver card selection utilizes a picker view with a **Done** button for confirmation.
  - Input accessory views provide a consistent experience.
- **Automatic Formatting**:
  - Card numbers are automatically formatted as users type (e.g., grouping digits for readability).
  - Phone numbers maintain the country code and enforce proper formatting.
- **Button States**:
  - Buttons like **Create Account** and **Transfer** are enabled only when all inputs are valid.
  - Disabled buttons are visually distinct to indicate they cannot be interacted with.

## Bug Prevention Measures

- **Input Restrictions**:
  - Text fields enforce character restrictions to prevent invalid inputs.
  - Delegates and target actions are used to monitor and control user input.
- **Validation Logic**:
  - Comprehensive validation ensures that all inputs meet the required criteria before proceeding.
- **Error Handling**:
  - The app gracefully handles errors, providing users with meaningful messages.
  - Edge cases, such as empty inputs or overflows, are accounted for.
- **Duplicate Prevention**:
  - Checks are in place to prevent adding duplicate cards.
- **Transfer Constraints**:
  - Users cannot transfer funds if they have only one card.
  - The app checks for sufficient balance before processing transfers.
- **Data Consistency**:
  - Updates to the data model are immediately reflected in the UI.
  - Observers and notifications ensure that changes propagate correctly.
- **User Guidance**:
  - The app provides prompts and guidance to prevent misuse or confusion.
  - Disabled fields and controls indicate when actions are not permissible.

## Contact

For any inquiries or feedback, please contact:

**Farid Rzayev**

- **Email**: faridrzyv@gmail.com
- **GitHub**: [github.com/faridrzayev](https://github.com/faridrza)
- **LinkedIn**: [linkedin.com/in/faridrzayev](https://www.linkedin.com/in/farid-rzayev-550375239/)

---

Thank you for checking out the ASolution Demo App! Your feedback is highly appreciated.
