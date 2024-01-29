# https://docs.llamaindex.ai/en/stable/use_cases/q_and_a/rag_cli.html

function ragAssistant {
    [CmdletBinding()]
    param(
        $Question,        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path,
        [Switch]$Chat,
        [Switch]$Clear
    )
    begin {
        $files = @()
    }

    process {
        #$files += Invoke-OAIUploadFile $Path
        $files += $Path
    }

    end {
        $files
    }    
}