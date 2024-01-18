# https://www.jimmymills.io/blog/openai-assistants-api/code-interpreter

. $PSScriptRoot\Invoke-DataQuery.ps1

$userInput = 'Please read the xlsx file. Need a bar chart for these "Units" sold by "Region"'
$userInput = 'Please read the xlsx file. Need a bar chart for these "Units" sold by "State"'

$r = Invoke-DataQuery -UserInput $userInput -FilePath $PSScriptRoot\Sales.xlsx

$messages = Get-OAIMessage -ThreadId $r.Thread.id

$fileId = $messages.data.content.image_file.file_id
if ($fileId) {
    Get-OAIFileContent -FileId $fileId -OutFile ./result-xlsx.jpg
    Write-Host "Result saved to $PSScriptRoot\result-xlsx.jpg"
}
else {
    Write-Error "No image found"
}

# $image = $messages[0].data[0].content[0]
# if ($image) {
#     $fileId = $image.image_file.file_id

#     Get-OAIFileContent -FileId $fileId -OutFile ./result-xlsx.jpg
#     Write-Host "Result saved to $PSScriptRoot\result-xlsx.jpg"
# }
# else {
#     Write-Error "No image found"
# }