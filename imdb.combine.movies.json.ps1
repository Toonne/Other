#Combine json files downloaded using https://github.com/Toonne/Other/blob/main/imdb.extract.data.from.list.js (or any set of json-files)

$movieFilesArray = [System.Collections.ArrayList]@();

$files = Get-ChildItem "movies*.json" | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) }

foreach ($file in $files) {
	#$file.Name;
	$movieFilesArray.AddRange((Get-Content -Path $file.Name -Raw | ConvertFrom-Json));
}

$movieFilesArray | ConvertTo-Json -Compress -Depth 5 | Out-File -FilePath .\combinedfiles.json
