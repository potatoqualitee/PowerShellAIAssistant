#Import-Module "$PSScriptRoot\..\PowerShellAIAssistant.psd1" -Force

# Define a function to get the payment status
function Get-PaymentStatus {
    param(
        $transaction_id  # Parameter for the transaction ID
    )

    # Return a string indicating the payment status for the given transaction ID
    return "Payment status for transaction $transaction_id is pending"
}

# Define a function to get the payment date
function Get-PaymentDate {
    param(
        $transaction_id  # Parameter for the transaction ID
    )

    # Return a string indicating the payment date for the given transaction ID
    return "Payment date for transaction $transaction_id is 2022-12-31"
}

# Get the function call specification for the Get-PaymentStatus function
$fcs1 = Get-OAIFunctionCallSpec (Get-Command Get-PaymentStatus)

# Get the function call specification for the Get-PaymentDate function
$fcs2 = Get-OAIFunctionCallSpec (Get-Command Get-PaymentDate)

# Create a new AI assistant named 'Payment Function' with the specified tools and model
New-OAIAssistant 'Payment Function' -Tools $fcs1, $fcs2, (Enable-OAIRetrievalTool), (Enable-OAICodeInterpreter) -Model gpt-4-turbo-preview