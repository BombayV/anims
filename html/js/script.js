import { createPanels } from "./modules/fetch.js";

window.addEventListener('load', () => {
    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))
});