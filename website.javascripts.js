//Random console javascript codes

//hide checked cards on Pokellector - https://www.pokellector.com/
document.querySelectorAll(".card.checked").forEach(e => e.remove());

//remove all texts on top of cards on Pokellector - https://www.pokellector.com/
document.querySelectorAll(".plaque").forEach(e => e.remove());

//remove opacity so cards are clearly visible on Pokellector - https://www.pokellector.com/
document.querySelectorAll(".cardlisting div.card img.card").forEach(e => e.style.opacity = "1");
