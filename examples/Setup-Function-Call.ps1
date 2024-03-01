function Get-PaymentStatus {
    param(
        $transaction_id
    )

    return "Payment status for transaction $transaction_id is pending"
}

function Get-PaymentDate {
    param(
        $transaction_id
    )

    return "Payment date for transaction $transaction_id is 2022-12-31"
}

$fcs1 = Get-OAIFunctionCallSpec 'Get-PaymentStatus'
$fcs2 = Get-OAIFunctionCallSpec 'Get-PaymentDate'

New-OAIAssistant 'Payment Function' -Tools $fcs1, $fcs2, (Enable-OAIRetrievalTool), (Enable-OAICodeInterpreter) -Model gpt-4-turbo-preview