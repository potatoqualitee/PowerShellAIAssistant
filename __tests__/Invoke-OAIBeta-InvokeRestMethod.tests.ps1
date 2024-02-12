Describe 'Test Invoke-OAIBeta InvokeRestMethod Params' -Tag Invoke-OAIBetaParams {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
        . "$PSScriptRoot/PesterMatchHashtable.ps1"

        $script:expectedBaseUrl = "https://api.openai.com/v1"
        $script:expectedHeaders = @{
            "Content-Type"  = "application/json"
            "OpenAI-Beta"   = "assistants=v1"
            "Authorization" = "Bearer "
        }

        function Test-UnitTestingData {
            param(
                [hashtable]$UnitTestingData,
                [hashtable]$ExpectedUnitTestingData
            )

            $UnitTestingData['Method'] | Should -BeExactly $ExpectedUnitTestingData['Method']
            $UnitTestingData['Uri'] | Should -BeExactly $ExpectedUnitTestingData['Uri']
            $UnitTestingData['OutFile'] | Should -BeExactly $ExpectedUnitTestingData['OutFile']
            $UnitTestingData['ContentType'] | Should -BeExactly $ExpectedUnitTestingData['ContentType']            

            $UnitTestingData['Body'] | Should -MatchHashtable $ExpectedUnitTestingData['Body']
            
            $resp = $UnitTestingData['Headers']            
            $resp.Authorization = $resp.Authorization -replace "Bearer.*", "Bearer " # Do not check the actual token
            $resp | Should -MatchHashtable $ExpectedUnitTestingData['Headers']

            $UnitTestingData['NotOpenAIBeta'] | Should -Be $ExpectedUnitTestingData['NotOpenAIBeta']
            $UnitTestingData['UseInsecureRedirect'] | Should -Be $ExpectedUnitTestingData['UseInsecureRedirect']
        }
    }

    BeforeEach {
        Enable-UnitTesting
    }

    AfterEach {
        Disable-UnitTesting
    }

    It 'Should have the expected data after New-OAIAssistant is called' {
        New-OAIAssistant

        $ExpectedUnitTestingData = @{
            Method              = 'Post'            
            Uri                 = "$expectedBaseUrl/assistants"            
            OutFile             = $null
            ContentType         = 'application/json'
            
            Body                = @{
                instructions = $null
                name         = $null
                model        = "gpt-3.5-turbo"
            }

            Headers             = $expectedHeaders

            NotOpenAIBeta       = $false
            UseInsecureRedirect = $false                     
        }

        $UnitTestingData = Get-UnitTestingData 
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
 
    It 'Should have the expected data after Get-OAIAssistant is called' {
        Get-OAIAssistant

        $ExpectedUnitTestingData = @{
            Method              = 'Get'
            Uri                 = "$expectedBaseUrl/assistants/"
            OutFile             = $null
            ContentType         = 'application/json'
            Body                = $null
            Headers             = $expectedHeaders
            NotOpenAIBeta       = $false
            UseInsecureRedirect = $true
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }    

    It "Should have the expected data after New-OAIThread is called" {
        New-OAIThread

        $ExpectedUnitTestingData = @{
            Method              = 'Post'
            Uri                 = "$expectedBaseUrl/threads"
            OutFile             = $null
            ContentType         = 'application/json'
            Body                = $null
            Headers             = $expectedHeaders
            NotOpenAIBeta       = $false
            UseInsecureRedirect = $false
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after New-OAIMessage is called" { 
        $tid = 1234
        New-OAIMessage -ThreadId $tid -Role user -Content 'what is the capital of France'

        $ExpectedUnitTestingData = @{
            Method              = 'Post'
            Uri                 = "$expectedBaseUrl/threads/$($tid)/messages"
            OutFile             = $null
            ContentType         = 'application/json'
            Body                = @{
                role    = 'user'
                content = 'what is the capital of France'
            }
            Headers             = $expectedHeaders
            NotOpenAIBeta       = $false
            UseInsecureRedirect = $false
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after New-OAIRun is called" {
        $tid = 1234
        $aid = 5678
        New-OAIRun -ThreadId $tid -AssistantId $aid

        $ExpectedUnitTestingData = @{
            Method              = 'Post'
            Uri                 = "$expectedBaseUrl/threads/$($tid)/runs"
            OutFile             = $null
            ContentType         = 'application/json'
            Body                = @{
                assistant_id = $aid
            }
            Headers             = $expectedHeaders
            NotOpenAIBeta       = $false
            UseInsecureRedirect = $false
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after Get-OAIMessage is called" {
        $tid = 1234
        Get-OAIMessage -ThreadId $tid

        $ExpectedUnitTestingData = @{
            Method              = 'Get'
            Uri                 = "$expectedBaseUrl/threads/$($tid)/messages?limit=20&order=desc"
            OutFile             = $null
            ContentType         = 'application/json'
            Body                = $null
            Headers             = $expectedHeaders
            NotOpenAIBeta       = $false
            UseInsecureRedirect = $false
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
}