/*

Usage:
1. Go to https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,video&release_date=1801-01-01,2023-12-31&sort=num_votes,desc&count=250
2. Paste the code below in console to download a json-file with information from the page

*/

/* jshint strict: true */
/* jshint esversion: 6 */
/* global $ */

function save(filename, data) {
	"use strict";
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
	"use strict";
	var title = $(this).find("h3 a").text().trim();
	var imdbId = $(this).find("h3 a").attr("href").trim().substring(7, 16);
	var year = $(this).find(".lister-item-header .text-muted").text().trim(); // "(I) (dddd)"

	let yearPattern = /\((\d{4})\)/i;
	let result = year.match(yearPattern);
	year = parseInt(result[1]);

	var rating = parseFloat($(this).find(".ratings-imdb-rating strong").text().trim());
	var votes = parseInt($(this).find(".sort-num_votes-visible span[name=nv]").first().text().trim().replaceAll(",", ""));
	var plot = null;
	var plotBox = $(this).find(".ratings-bar").next();
	if(plotBox.hasClass("text-muted")) {
		plot = $(this).find(".ratings-bar").next().text().trim();
	}
	var certificate = $(this).find("p.text-muted .certificate").text().trim();
	var runtime = $(this).find("p.text-muted .runtime").text().trim();
	var genre = $(this).find("p.text-muted .genre").text().trim().split(",").map(element => element.trim());

	var obj = {
		title : title,
		imdbId : imdbId,
		year : year,
		rating : rating,
		votes : votes,
		plot : plot,
		certificate : certificate,
		runetime : runtime,
		genre : genre
	};

	movieList.push(obj);
});

save("movies.json", JSON.stringify(movieList, null, "\t"));
