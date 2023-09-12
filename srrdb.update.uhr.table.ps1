#
# Updates the table [user_have_releases] with specified locations
#

#Config
$releaseFolders = @("M:\Movies.720p\", "M:\Movies.1080p\", "M:\Movies.SD\");

$connection = New-Object System.Data.SQLClient.SQLConnection;
$connection.ConnectionString = "Server='WEB-01';database='srrdb';Integrated Security=SSPI;";
$connection.Open();
$command = New-Object System.Data.SQLClient.SQLCommand;
$command.Connection = $connection;

$releases = @();

Write-Output "Getting directory listing...";

foreach($releaseFolder in $releaseFolders) {
	Write-Output "...for [$releaseFolder]";
	$releases += Get-ChildItem -Path $releaseFolder -Directory -Exclude "_*" -Force -ErrorAction SilentlyContinue | Select-Object Name;
}

Write-Output "Sorting list alphabetically";

#Sort combined release list alphabetically (optional)
$releases = $releases | Sort-Object -Property { $_.Name };

Write-Output "Truncating old results";

#First truncate existing data...
$command.CommandText = "TRUNCATE TABLE [user_have_releases]";
$command.ExecuteNonQuery();

Write-Output "Adding releases";

#...then add all releases
foreach($release in $releases) {
	$releaseName = $release.Name;

	if ($releaseName -match "CSEI2P~Z")
	{
		$releaseName = "Con.Man.2018.STV.720p.BluRay.x264-TheWretched";
	}

	$insertquery = "INSERT INTO user_have_releases (Release) VALUES ('$releaseName')";
	$command.CommandText = $insertquery;
	$command.ExecuteNonQuery();
}

Write-Output "All done";
