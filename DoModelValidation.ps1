function ValidateAIModel {    
    $provider = Get-OAIProvider
    if ($provider -eq 'OpenAI') {
        $modelList = 'a', 'b', 'c'
        if ($_ -in $modelList) {
            $true
        }
        else {
            throw 'Invalid model. Valid models are: ' + $modelList
        }
    }
    elseif ($provider -eq 'AzureOpenAI') {
        $true
    }    
    
}
function yyz {
    param(
        [ValidateScript({ ValidateAIModel })]
        [string]$model
    )
 
    'You selected: ' + $model
}