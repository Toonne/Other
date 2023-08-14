#
# Updates the table [user_have_releases] with specified locations
#

#Config
$releaseFolders = @("M:\Movies.720p\", "M:\Movies.1080p\")

$Connection = New-Object System.Data.SQLClient.SQLConnection;
$Connection.ConnectionString = "Server='WEB-01';database='srrdb';Integrated Security=SSPI;";
$Connection.Open();
$Command = New-Object System.Data.SQLClient.SQLCommand;
$Command.Connection = $Connection;

$releases = @();

foreach($releaseFolder in $releaseFolders) {
	$releases += Get-ChildItem -Path $releaseFolder -Directory -Exclude "_*" -Force -ErrorAction SilentlyContinue | Select-Object Name
}

#Sort combined release list alphabetical (optional)
$releases = $releases | Sort-Object -Property { $_.Name };

#First truncate existing data...
$Command.CommandText = "TRUNCATE TABLE [user_have_releases]";
$Command.ExecuteNonQuery();

#...then add all releases
foreach($release in $releases) {
	$releaseName = $release.Name;

	if ($releaseName -match "CSEI2P~Z")
	{
		$releaseName = "Con.Man.2018.STV.720p.BluRay.x264-TheWretched"
	}

	$insertquery = "INSERT INTO user_have_releases (Release) VALUES ('" + $releaseName + "')";
	$Command.CommandText = $insertquery;
	$Command.ExecuteNonQuery();
}
