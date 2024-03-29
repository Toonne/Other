// ==UserScript==
// @name		Download JSON structures from IMDB
// @namespace	https://srrdb.com/
// @version		0.1
// @description	Adds a "Download JSON structure" button to imdb lists
// @author		Skalman
// @match		https://imdb.com/search/title/*
// @match		https://*.imdb.com/search/title/*
// @grant		none
// ==/UserScript==

/*global $*/
/*jshint esversion: 6 */

//https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,video&release_date=1801-01-01,2023-12-31&sort=num_votes,desc&count=25
//https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,video&release_date=1801-01-01,2023-12-31&sort=num_votes,desc&count=250
//https://www.imdb.com/search/title/?count=100&groups=top_1000&sort=user_rating
//https://www.imdb.com/search/title/?groups=top_1000&sort=num_votes,desc
//https://www.imdb.com/search/title/?num_votes=100000,&sort=num_votes,desc

//More title_type URLs:
//https://www.imdb.com/search/title/?title_type=feature,tv_movie,tv_special,video,tv_series,mini_series,game&release_date=1801-01-01,2023-12-31&sort=num_votes,desc&count=250

//TODO: add support for directory, stars & gross

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

function getMovieList() {
	let movieList = [];

	$(".lister-item").each(function() {
		"use strict";
		let title = $(this).find("h3 a").text().trim();
		let imdbUrl = $(this).find("h3 a").attr("href").trim();
		let imdbPattern = /\/title\/tt(.*?)\//;
		let result1 = imdbUrl.match(imdbPattern);
		let imdbId = result1[1];
		let year = $(this).find(".lister-item-header .text-muted").text().trim(); // "(I) (dddd)"

		//ugly fix
		year = year.replace(" TV Movie", "");
		year = year.replace(" Video", "");
		year = year.replace(" TV Special", "");

		let yearPattern = /\((\d{4})\)/i;
		let result = year.match(yearPattern);
		year = parseInt(result[1]);

		let rating = parseFloat($(this).find(".ratings-imdb-rating strong").text().trim());
		let metascore = parseInt($(this).find(".ratings-metascore .metascore").text().trim());
		let votes = parseInt($(this).find(".sort-num_votes-visible span[name=nv]").first().text().trim().replaceAll(",", ""));
		let plot = null; //the plot string
		let plotBox = $(this).find(".ratings-bar").next();

		if(plotBox.hasClass("text-muted")) {
			plot = plotBox.text().trim();
		} else {
			//if we got here, starsBox will probably fail too
		}
		let starsBox = plotBox.next();
		let starsList = starsBox.find("a");
		let stars = [];

		starsList.each(function() {
			let personUrl = $(this).attr("href").trim();

			let starsPattern = /\/name\/nm(.*?)\//;
			let result2 = personUrl.match(starsPattern);

			let personId = result2[1];
			let name = $(this).text().trim();

			let starObj = {
				personId : personId,
				name : name
			};

			stars.push(starObj);
		});

		let certificate = $(this).find("p.text-muted .certificate").text().trim();
		let runtime = $(this).find("p.text-muted .runtime").text().trim();
		let genre = $(this).find("p.text-muted .genre").text().trim().split(",").map(element => element.trim());
		let posterUrl = $(this).find(".lister-item-image img").attr("src");

		let obj = {
			title : title,
			imdbId : imdbId,
			year : year,
			rating : rating,
			votes : votes,
			plot : plot,
			certificate : certificate,
			runtime : runtime,
			genre : genre,
			posterUrl : posterUrl,
			metascore : metascore,
			stars: stars
		};

		movieList.push(obj);
	});

	return movieList;
}

function saveJson() {
	let movies = getMovieList();

	//get current page
	let pageCountString = $(".nav .desc span:first-child").text().trim().replace(/,/g, "");

	let pagePattern = /(\d+)\-(\d+) of (\d+) titles/;
	let result3 = pageCountString.match(pagePattern);
	let pageStart = result3[1];
	let pageEnd = result3[2];
	let resultTotal = result3[3];

	let fileName = "movies_" + pageStart + "-" + pageEnd + ".json";

	save(fileName, JSON.stringify(movies, null, "\t"));
}

(function() {
	'use strict';

	console.clear();

	$('<div style="margin-top: 12px;"><a id="download-json" href="#">Download JSON structure</a></div>').insertAfter(".nav");

	$("body").on("click", "#download-json", function(evt) {
		saveJson();

		evt.preventDefault();
	});
})();
