#
# A PowerShell script to build a user-friendly structure for TV-series to be used for Plex
# - Uses .plexmatch for naming if it exists
# - Uses .episodematch (per show) to redirect episodes to another Season and/or Episode
#

$sourcePath = "T:"; #set this to the source of where your TV-shows are
$destinationPath = "D:\TV-Symlinks"; #set this to the destination of the user-friendly directory

$series = Get-ChildItem -Path $sourcePath

foreach ($serie in $series) {
	$serieName = $serie.Name;
	$serieFormattedName = $serieName.replace("."," "); #TODO: read title:xxx from .plexmatch
	$hasPlexMatch = $false;
	$episodeMatch = @{};
	$plexMatch = @{};

	$sourceSerie = ($sourcePath + "\" + $serieName);

	#read title from plexmatch:
	if((Test-Path -Path ($sourceSerie + "\" + ".plexmatch"))) {
		$hasPlexMatch = $true;

		$plexMatchContent = Get-Content -Path ($sourceSerie + "\" + ".plexmatch") -Encoding UTF8;

		foreach($line in $plexMatchContent) {
			if($line -match ': ') {
				$lineData = $line -split ": ";
				$plexMatch[$lineData[0]] = $lineData[1];
			}
		}
	}

	#use title from plexmatch file
	if($plexMatch.ContainsKey("title")) {
		$serieFormattedName = $plexMatch["title"];
	}

	$destinationSerie = ($destinationPath + "\" + $serieFormattedName);

	if(!(Test-Path -Path ($destinationSerie))) {
		New-Item -Path $destinationPath -Name $serieFormattedName -ItemType "Directory";
	}

	if($hasPlexMatch -and (!(Test-Path -Path ($destinationSerie + "\" + ".plexmatch")))) {
		New-Item -ItemType SymbolicLink -Path ($destinationSerie + "\" + ".plexmatch") -Value ($sourceSerie + "\" + ".plexmatch");
	}

	#read episodematch
	if((Test-Path -Path ($sourceSerie + "\" + ".episodematch"))) {
		$episodeMatchContent = Get-Content -Path ($sourceSerie + "\" + ".episodematch");

		foreach($line in $episodeMatchContent) {
			if($line -match '.* = .*') {
				$lineData = $line -split " = ";
				$episodeMatch[$lineData[0]] = $lineData[1];
			}
		}
	}

	$seasons = Get-ChildItem -Path ($sourcePath + "\" + $serie.Name);
	
	foreach ($season in $seasons) {
		if($season.Name -match '\.S(\d{2})\.' -or $season.Name -match '.(\d{1})\.DVDRip_XviD') {
			$seasonNumbering = $matches.1;

			if($seasonNumbering.Length -eq 1) {
				$seasonNumbering = ("0" + $seasonNumbering); #always 01 season etc, 1x01, FoV fix
			}

			$seasonFormat = ("Season " + $seasonNumbering);

			$sourceSeason = ($sourceSerie + "\" + $season.Name);
			$destinationSeason = ($destinationSerie + "\" + $seasonFormat);

			if(!(Test-Path -Path $destinationSeason)) {
				New-Item -Path $destinationSerie -Name $seasonFormat -ItemType "Directory";
			}

			$episodes = Get-ChildItem -Path ($sourcePath + "\" + $serie.Name + "\" + $season.Name) -Directory;
			
			foreach ($episode in $episodes) {
				$episodeName = $episode.Name;
				$sourceEpisode = ($sourceSeason + "\" + $episodeName);
				$destinationEpisode = ($destinationSeason + "\" + $episodeName);
				$matchEpisodeName = ($season.Name + "\" + $episodeName);

				if($episodeName -match "DIRFIX") {
					#is a dirfix, check one level deeper, get first directory
					$newDir = (Get-ChildItem -Path $episode.FullName -Directory | Select-Object -First 1).Name

					#overwrite with dirfix included in path
					$sourceEpisode = ($sourceSeason + "\" + $episodeName + "\" + $newDir);
					
					$matchEpisodeName = ($season.Name + "\" + $episodeName + "\" + $newDir)
				}

				if($episodeMatch.ContainsKey($matchEpisodeName)) { #relative path
					#overwrite destination with episodeMatch
					$destinationEpisode = ($destinationSeason + "\" + $episodeMatch[($matchEpisodeName)]);

					if($episodeMatch[($season.Name + "\" + $episodeName)] -match "\\") {
						#support fixing episode to another season
						$newSeasonMap = $episodeMatch[($matchEpisodeName)] -split "\\";

						#create folder if it doesn't exists
						if(!(Test-Path -Path ($destinationSerie + "\" + $newSeasonMap[0]))) {
							New-Item -Path $destinationSerie -Name $newSeasonMap[0] -ItemType "Directory";
						}

						$destinationEpisode = ($destinationSerie + "\" + $episodeMatch[($matchEpisodeName)]);
					}
				}

				if(!(Test-Path -Path $destinationEpisode)) {
					New-Item -ItemType Junction -Path $destinationEpisode -Value $sourceEpisode
				}
			}
		}
		
		#break;
	}

	#break;
	Write-Output ("Done " + $serie.Name);
}

#symlink plexignore in root if it exists and isn't already symlinked
if((Test-Path -Path ($sourcePath + "\.plexignore")) -and
  !(Test-Path -Path ($destinationPath + "\.plexignore"))) {
	New-Item -ItemType Junction -Path ($destinationPath + "\.plexignore") -Value ($sourcePath + "\.plexignore")
}
