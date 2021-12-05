import { createPanels } from "./modules/fetch.js";

window.addEventListener('load', () => {
    //window.localStorage.clear()
    const favorites = JSON.parse(localStorage.getItem('favoriteAnims'))
    if (favorites == null) {
        console.log("NEW")
        localStorage.setItem('favoriteAnims', JSON.stringify([]))
    }

    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))

});