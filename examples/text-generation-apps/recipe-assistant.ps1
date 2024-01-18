$noRecipes = Read-Host "No of recipes (for example, 5) "

$ingredients = Read-Host "List of ingredients (for example, chicken, potatoes, and carrots) "

$filter = Read-Host "Filter (for example, vegetarian, vegan, or gluten-free) "

$prompt = @"
Show me $noRecipes recipes for a dish with the following ingredients: $ingredients. Per recipe, list all the ingredients used, no $($filter): 
"@

$assistant = New-OAIAssistant

$queryResult = New-OAIThreadQuery -UserInput $prompt -Assistant $assistant

"Getting recipes - Thinking ..."
$queryResult.run = Wait-OAIOnRun -Run $queryResult.run -Thread $queryResult.Thread

$promptShopping = @"
Produce a shopping list, and please don't include ingredients that I already have at home:
"@

$newPrompt = @"
Given ingredients at home $ingredients and these generated recipes: $prompt, $promptShopping
"@

$submitResult = Submit-OAIMessage -Assistant $assistant -Thread $queryResult.Thread -UserInput $newPrompt

"Getting shopping list - Thinking ..."
$submitResult.run = Wait-OAIOnRun -Run $submitResult.run -Thread $queryResult.Thread

$messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id -Order asc

Out-OAIMessages -Messages $messages.data -NoHeader

$null = Remove-OAIAssistant -Id $assistant.Id