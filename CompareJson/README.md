## Synopsis
Compare two JSON files and return a difference file.

## Description
Given a reference and comparison file, this function will recursively compare the objects
within two JSON files by a specified ID. ConvertToHashtable.ps1 is required to ensure that
the incoming objects during recursion are in the correct format. WriteLine.ps1 is used
to improve readability during debugging.

## Usage
```powershell
Import-Module .\CompareJson.ps1
Compare-Json -ReferenceFile .\ReferenceFile.json -ComparisonFile .\ComparisonFile.json
```