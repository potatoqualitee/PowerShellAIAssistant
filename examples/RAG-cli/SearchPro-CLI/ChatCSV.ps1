# Import-Module $PSScriptRoot\SearchPro-CLI.psm1 -Force

# $q = "
# What's the name of the customer who bought the most and the name of that product?
# Take your time.
# - first figure out the schema
# - then figure out how the joins between files happen
# "
# Get-ChildItem $PSScriptRoot *csv | ragcode -Question $q