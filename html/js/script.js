import { createPanels, fetchNUI } from "./modules/fetch.js";
import { setDisplay } from "./modules/functions.js";

window.addEventListener('load', (e) => {
    window.addEventListener('message', e => {
        switch (e.data.action) {
            case 'panelStatus':
                if (e.data.panelStatus) {
                    setDisplay('fadeIn');
                } else {
                    setDisplay('fadeOut');
                }
            break;

            default:
                console.log('Something did not load properly when sending a message')
            break;
        }
    })

    document.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            fetchNUI('exitPanel');
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
        fetchNUI('fetchStorage', animOpts)
        for (let i = 0; i < animOpts.length; i++) {
            document.getElementById(animOpts[i]).style.backgroundColor = "#ff0d4ecc";
        }
    }

    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))
});