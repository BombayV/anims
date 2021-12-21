import { changeClass, getStatus, changeInfo } from "./modules/functions.js";
import { fetchNUI } from "./modules/fetch.js"

const doc = document;

doc.getElementById('home').addEventListener('mouseover', _ => changeInfo(true, 'home', 'Show all animations.'));
doc.getElementById('home').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('home').addEventListener('click', e => changeClass(e.target));

doc.getElementById('settings').addEventListener('mouseover', _ => changeInfo(true, 'settings', 'Show the animation menu settings.'));
doc.getElementById('settings').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('settings').addEventListener('click', e => changeClass(e.target));

doc.getElementById('exit').addEventListener('mouseover', _ => changeInfo(true, 'exit', 'Close the animation menu.'));
doc.getElementById('exit').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('exit').addEventListener('click', e => {
    changeClass(doc.getElementById('home'));
    fetchNUI('exitPanel');
});

doc.addEventListener('keyup', e => {
    if (e.key == 'Escape') {
        changeClass(doc.getElementById('home'));
        fetchNUI('exitPanel');
    }
})

doc.getElementById('favorite').addEventListener('mouseover', _ => changeInfo(true, 'favorites', 'Show your bookmarked animations.'));
doc.getElementById('favorite').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('favorite').addEventListener('click', e => changeClass(e.target));

doc.getElementById('dances').addEventListener('mouseover', _ => changeInfo(true, 'dances', 'Show dancing animations.'));
doc.getElementById('dances').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('dances').addEventListener('click', e => changeClass(e.target));

doc.getElementById('scenarios').addEventListener('mouseover', _ => changeInfo(true, 'scenarios', 'Show scenario animations.'));
doc.getElementById('scenarios').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('scenarios').addEventListener('click', e => changeClass(e.target));

doc.getElementById('walks').addEventListener('mouseover', _ => changeInfo(true, 'walks', 'Show walking animations.'));
doc.getElementById('walks').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('walks').addEventListener('click', e => changeClass(e.target));

doc.getElementById('expressions').addEventListener('mouseover', _ => changeInfo(true, 'expressions', 'Show facial expressions.'));
doc.getElementById('expressions').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('expressions').addEventListener('click', e => changeClass(e.target));

doc.getElementById('shared').addEventListener('mouseover', _ => changeInfo(true, 'shared', 'Show shared animations.'));
doc.getElementById('shared').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('shared').addEventListener('click', e => changeClass(e.target));

doc.getElementById('search-bar').addEventListener('input', e => {
    let input = e.target.value.toUpperCase();
    const panels = doc.getElementsByClassName('anim');
    for (let i = 0; i < panels.length; i++) {
        let text = panels[i].getElementsByTagName('div')[0].firstChild
        let val = text.textContent || text.innerText;
        if (val.toUpperCase().indexOf(input) > -1) {
            panels[i].style.display = "";
        } else {
            text = panels[i].getElementsByTagName('div')[0].lastChild
            val = text.textContent || text.innerText;
            if (val.toUpperCase().indexOf(input) > -1) {
                panels[i].style.display = "";
            } else {
                panels[i].style.display = "none";
            }
        }
    }
})


doc.getElementById('cancel').addEventListener('mouseover', _ => changeInfo(true, 'Cancel', 'Cancel current playing animation.'));
doc.getElementById('cancel').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('cancel').addEventListener('click', e => {
    e.target.classList.add('pop');
    e.target.style.backgroundColor = "#ff0d4ecc";
    setTimeout(() => {
        e.target.classList.remove('pop');
        e.target.style.backgroundColor = '#000000cc';
    }, 300);
    fetchNUI('cancelAnimation');
});

doc.getElementById('delete').addEventListener('mouseover', _ => changeInfo(true, 'Delete Props', 'Deletes all props if you have them stuck to you.'));
doc.getElementById('delete').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('delete').addEventListener('click', e => {
    e.target.classList.add('pop');
    e.target.style.backgroundColor = "#ff0d4ecc";
    setTimeout(() => {
        e.target.classList.remove('pop');
        e.target.style.backgroundColor = '#000000cc';
    }, 300);
    fetchNUI('removeProps');
});
doc.getElementById('movement').addEventListener('mouseover', _ => changeInfo(true, 'Movement', 'Allows movement while playing an animation (not shared).'));
doc.getElementById('movement').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('movement').addEventListener('click', e => (getStatus(e.target)));

doc.getElementById('loop').addEventListener('mouseover', _ => changeInfo(true, 'Loop', 'Loops animations (overwrites duration in animations).'));
doc.getElementById('loop').addEventListener('mouseleave', _ => changeInfo(false));
doc.getElementById('loop').addEventListener('click', e => getStatus(e.target));

doc.getElementById('save-settings').addEventListener('click', () => {
    const duration = doc.getElementById('set-duration');
    const cancel = doc.getElementById('set-cancel');
    const emote = doc.getElementById('set-emote');
    const key = doc.getElementById('set-key');
    if (duration.value) {
        localStorage.setItem('currentDuration', duration.value);
        duration.placeholder = duration.value;
    }

    if (cancel.value) {
        localStorage.setItem('currentCancel', cancel.value);
        cancel.placeholder = cancel.value;
    }

    if (emote.value) {
        localStorage.setItem('currentEmote', emote.value);
        emote.placeholder = emote.value;
    }

    if (key.value) {
        localStorage.setItem('currentKey', key.value);
        key.placeholder = key.value;
    }
    fetchNUI('changeCfg', {type: 'settings', duration: duration.value, cancel: cancel.value, emote: emote.value, key: key.value})

    duration.value = '';
    cancel.value = '';
    emote.value = '';
    key.value = '';
})

doc.getElementById('reset-duration').addEventListener('click', _ => {
    localStorage.setItem('currentDuration', 1500);
    doc.getElementById('set-duration').placeholder = 1500;
    fetchNUI('changeCfg', {type: 'settings', duration: 1500})
});

doc.getElementById('reset-cancel').addEventListener('click', _ => {
    localStorage.setItem('currentCancel', 73);
    doc.getElementById('set-cancel').placeholder = 73;
    fetchNUI('changeCfg', {type: 'settings', cancel: 73})
});

doc.getElementById('reset-fav').addEventListener('click', _ => {
    localStorage.setItem('currentEmote', 'dance');
    doc.getElementById('set-emote').placeholder = 'dance';
    fetchNUI('changeCfg', {type: 'settings', emote: 'dance'})
});

doc.getElementById('reset-key').addEventListener('click', _ => {
    localStorage.setItem('currentKey', 20);
    doc.getElementById('set-key').placeholder = 20;
    fetchNUI('changeCfg', {type: 'settings', key: 20})
});


doc.getElementById('reset-favs').addEventListener('click', _ => {
    const favorites = JSON.parse(localStorage.getItem('favoriteAnims'))
    const anims = document.getElementsByClassName('anim')
    for (let i = 0; i < anims.length; i++) {
        for (let x = 0; x < favorites.length; x++) {
            if (anims[i].id == favorites[x]) {
                anims[i].classList.remove('favorite');
                anims[i].getElementsByTagName("span")[2].style.color = '#999999';
            }
        }
    }
    localStorage.setItem('favoriteAnims', JSON.stringify([]))
});
