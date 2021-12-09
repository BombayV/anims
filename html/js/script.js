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

            case 'findEmote':
                const panels = document.getElementsByClassName('anim');
                for (let i = 0; i < panels.length; i++) {
                    let panelEmote = panels[i].childNodes[0].lastChild.textContent.split(" ")[1];
                    if (panelEmote.toLowerCase() == e.data.name.toLowerCase()) {
                        fetchNUI('beginAnimation', {dance: JSON.parse(panels[i].getAttribute('data-dances')), scene: JSON.parse(panels[i].getAttribute('data-scenarios')), expression: JSON.parse(panels[i].getAttribute('data-expressions')), walk: JSON.parse(panels[i].getAttribute('data-walks')), prop: JSON.parse(panels[i].getAttribute('data-props')), particle: JSON.parse(panels[i].getAttribute('data-particles'))}).then((resp) => {
                            (resp.e)
                                ? fetchNUI('sendNotification', {type: 'success', message: 'Animation executed!'})
                                : fetchNUI('sendNotification', {type: 'error', message: 'Animation could not load!'});
                            return;
                        })
                        return;
                    }
                }
                fetchNUI('sendNotification', {type: 'info', message: 'Animation was not found...'})
            break;

            default:
                console.log('Something did not load properly when sending a message')
            break;
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