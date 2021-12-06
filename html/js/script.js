import { createPanels } from "./modules/fetch.js";
import { setDisplay } from "./modules/functions.js";

window.addEventListener('load', (e) => {
    let panelStatus = false
    e.target.addEventListener('load', e => {
        switch (e.data.message) {
            case 'panelStatus':
                if (!panelStatus) {

                } else {

                }
            break;

            default:

            break;
        }
    })

    document.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            setDisplay('fadeIn');
        }
    })

    //window.localStorage.clear()
    const favorites = JSON.parse(localStorage.getItem('favoriteAnims'))
    if (favorites == null) {
        console.log("NEW")
        localStorage.setItem('favoriteAnims', JSON.stringify([]))
    }

    const animOpts = JSON.parse(localStorage.getItem('animOptions'))
    if (animOpts == null) {
        console.log("NEW")
        localStorage.setItem('animOptions', JSON.stringify([]))
    } else {
        for (let i = 0; i < animOpts.length; i++) {
            console.log(animOpts[i])
            document.getElementById(animOpts[i]).style.backgroundColor = "#ff0d4ecc";
        }
    }

    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))
});