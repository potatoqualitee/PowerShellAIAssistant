# https://www.jimmymills.io/blog/openai-assistants-api/code-interpreter

. $PSScriptRoot\Invoke-DataQuery.ps1

$userInput = 'Need a bar chart for these "Units" sold by "Region"'
$userInput = 'Need a bar chart for these "Units" sold by "State"'

$r = Invoke-DataQuery -UserInput $userInput -FilePath $PSScriptRoot\Sales.csv

$messages = Get-OAIMessage -ThreadId $r.Thread.id
$image = $messages[0].data[0].content[0]
if ($image) {
    $fileId = $image.image_file.file_id
    Get-OAIFileContent -FileId $fileId -OutFile ./result.jpg
    Write-Host "Result saved to $PSScriptRoot\result.jpg"
}
else {
    Write-Error "No image found"
}