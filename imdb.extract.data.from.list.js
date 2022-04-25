/*

Usage:
1. Go to https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,video&release_date=1801-01-01,2023-12-31&sort=num_votes,desc&count=250
2. Paste the code below in console to download a json-file with information from the page

*/

function save(filename, data) {
	const blob = new Blob([data], {type: 'text/csv'});
	if(window.navigator.msSaveOrOpenBlob) {
		window.navigator.msSaveBlob(blob, filename);
	} else{
		const elem = window.document.createElement('a');
		elem.href = window.URL.createObjectURL(blob);
		elem.download = filename;		
		document.body.appendChild(elem);
		elem.click();		
		document.body.removeChild(elem);
	}
}

var movieList = [];

$(".lister-item").each(function() {
	var title = $(this).find("h3 a").text().trim();
	var imdbId = $(this).find("h3 a").attr("href").trim().substring(7, 16);
	var year = $(this).find(".lister-item-header .text-muted").text().trim(); // (I) (dddd)

	let yearPattern = /\((\d{4})\)/i;
	let result = year.match(yearPattern);
	year = parseInt(result[1]);

	var rating = parseFloat($(this).find(".ratings-imdb-rating strong").text().trim());
	var votes = parseInt($(this).find(".sort-num_votes-visible span[name=nv]").first().text().trim().replaceAll(",", ""));

	var obj = {
		title : title,
		imdbId : imdbId,
		year : year,
		rating : rating,
		votes : votes
	}
	
	movieList.push(obj)
});

save("test.json", JSON.stringify(movieList, null, "\t"));
