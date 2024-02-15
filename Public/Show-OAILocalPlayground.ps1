<#
.SYNOPSIS
Starts a local playground interface that lets you play with OAI
#>

function Show-OAILocalPlayground {
    param(
        $port = 8080
    )
    $script:port = $port

    if (-not $ENV:OpenAIKey) {
        Write-Warning 'No $ENV:OpenAIKey found.'
    }

    # When someone clones the PowerShellAIAssistant repo, but it isn't in any PSModulePath, the playground will fail.
    if (-not (Get-Module -list PowerShellAIAssistant)) {
        throw 'PowerShellAIAssistant not found in any module directories. Please add a PSModulePath to the correct location if using a custom one. e.g. $ENV:PSModulePath += "; $pwd"'
    }

    # Avoid the ugly logic of (-not () -or -not ())
    if ((Get-Module -list Pode) -and (Get-Module -list Pode.Web)) {}
    else {
        # Get enthusiastic consent before installing extra modules on someone's system
        if ("y" -eq (Read-Host "The local playground requires Pode and Pode.Web. Type 'y' to install to local user from PSGallery")) {
            if (-not (Get-Module -list Pode)) { Install-Module Pode -Scope CurrentUser -Force }
            if (-not (Get-Module -list Pode.Web)) { Install-Module Pode.Web -Scope CurrentUser -Force }
        }
        else {
            throw "Pode and Pode.Web are not installed and consent was not given."
        }
    }


    Import-Module Pode.Web -Scope Global

    Start-PodeServer {
        $endpoint_param = @{
            Address  = "localhost"
            Port     = $script:port
            Protocol = "Http"
            Name     = "Local Playground"
        }

        Add-PodeEndpoint @endpoint_param
        Enable-PodeSessionMiddleware -Duration ([int]::MaxValue)

        Use-PodeWebTemplates -Title SampleApp -Theme Dark

        New-PodeLockable "assistantList_lock"
        Set-PodeState -Name "assistantList" -Value @()

        $assistantList = Get-OAIAssistant
        Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
            Set-PodeState -Name "assistantList" -Value $assistantList
        }

        Add-PodeWebPage -Name CodeHistory -DisplayName "Code history" -ScriptBlock {
            New-PodeWebCard -Content @(
                New-PodeWebTextbox -Name "Cmdlets" -Placeholder ((Get-PodeObject -Name "historyList") -join "`n")
            )
        }

        Add-PodeWebPage -Name ChatGPT -ScriptBlock {
            New-PodeWebCard -Content @(
                New-PodeWebButton -Name "Update assistant list" -ScriptBlock {
                    $assistantList = Get-OAIAssistant

                    Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
                        Set-PodeState -Name "assistantList" -Value $assistantList
                    }
                    Move-PodeWebUrl -Url /pages/ChatGPT
                }
            )

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'Example' -Content @(
                    New-PodeWebSelect -Name "Assistant" -Options (Get-PodeState -Name "assistantList").id -DisplayOptions (Get-PodeState -Name "assistantList").Name
                    New-PodeWebTextbox -Name 'Message'
                ) -ScriptBlock {

                    $message = $WebEvent.Data['Message']
                    if (-not $WebEvent.Session.Data.chat) { $WebEvent.Session.Data.chat = @() }

                    $message += "`r`n"
                    $WebEvent.Session.Data.chat += "$(Get-Date) (You):$message"

                    # OpenAI Assistant API
                    $assistant = New-OAIAssistant -Name 'Math Tutor' -Instructions 'You are a helpful math assistant. Please explain your answers.'
                    $queryResult = New-OAIThreadQuery -Assistant $assistant -UserInput $message
                    $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
                    $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id -Order asc
                    $messages.data.content.text.value | Out-String | Out-PodeWebTextbox -Multiline -ReadOnly

                    Clear-PodeWebTextbox -Name Message
                }
            ) -CssStyle @{"max-width" = "800px" }
        }



        ConvertTo-PodeWebPage -Module PowerShellAIAssistant -Commands @(
            "New-OAIAssistant"
            "New-OAIThreadQuery"
            "Wait-OAIOnRun"
            "Get-OAIMessage"
        )
    }



}
