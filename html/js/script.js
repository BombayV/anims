import { createPanels } from "./modules/fetch.js";

window.addEventListener('load', () => {
    window.localStorage.clear()
    if (localStorage.getItem('favoriteAnims') == null) {
        localStorage.setItem('favoriteAnims', JSON.stringify([]))
    }

    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))
});