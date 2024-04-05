Describe 'New-OAIRun' -Tag New-OAIRun {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIRun -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases.Contains('thread_id') | Should -Be $true        

        $actual.Parameters.Keys.Contains('AssistantId') | Should -Be $true
        $actual.Parameters.AssistantId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.AssistantId.Aliases.Count | Should -Be 1
        $actual.Parameters.AssistantId.Aliases.Contains('id') | Should -Be $true

        $actual.Parameters.Keys.Contains('Model') | Should -Be $true
        # $ValidateSet = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        # $ValidateSet | Should -Not -BeNullOrEmpty

        # $validValues = $actual.Parameters['model'].Attributes.ValidValues
        # $validValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106')

        # $validateScript = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateScriptAttribute] }
        # $validateScript | Should -Not -BeNullOrEmpty
        # $scriptBlock = $validateScript.ScriptBlock
        # $scriptBlock.ToString().Trim() | Should -BeExactly 'Test-LLMModel'

        $actual.Parameters.Keys.Contains('Instructions') | Should -Be $true
        $actual.Parameters.Keys.Contains('Tools') | Should -Be $true
        $actual.Parameters.Keys.Contains('Metadata') | Should -Be $true
    }
}