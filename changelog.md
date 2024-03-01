# v0.2.1

- Added `Get-OAIFunctionCallSpec` - Retrieves the OpenAI function call specification for the specified PowerShell functions.
- Added `ConvertTo-ToolFormat` - Converts an array of functions into a tool format.
- Thank you to [Devin](https://github.com/Szeraax) for `Show-OAILocalPlayground`. A Pode Web App that allows you to interact with ChatGPT with the module in a web page.
- Refactor Get-OAIRun function and add pipeline parameter and alias

# v0.2.0

- Supports Azure OpenAI AI Assistant instances
    - **Not** the previous Azure OpenAI instances
- **Not** pinned to PowerShell 7.4.0 and greater
- Add another model for `Update-OAIAssistant` - `gpt-4-turbo-preview`

# v0.1.7

Thank you to [Philosoraptor](https://github.com/asheroto)

- Organized the README, and fix API key instructions
- Fixed the API Key variable in [examples/Sanity-Check.ps1](/examples/Sanity-Check.ps1)

# v0.1.6

- Added `Invoke-SimpleQuestion` and `Invoke-QuickChat`

# v0.1.5

- Added new OpenAI model `gpt-4-turbo-preview`

# v0.1.4

- Fix dot source of file. Add .ps1

# v0.1.3

- Added `ConvertFrom-OAIAssistant` - Converts an AI assistant object to JSON.
- Added `ConvertTo-OAIAssistant` - Converts a JSON string to an AI assistant object.

# v0.1.2

- Updated `Invoke-OAIChat` to improve processing input prompt

    ```powershell
    git status | ai 'write a detailed commit message'
    ```

# v0.1.1

- Added `Invoke-OAIChat` alias `ai`