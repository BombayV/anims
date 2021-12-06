import { changeClass, getStatus, setDisplay } from "./modules/functions.js";
import { fetchNUI } from "./modules/fetch.js"

const doc = document;

doc.getElementById('home').addEventListener('click', e => {
    changeClass(e.target);
});

doc.getElementById('settings').addEventListener('click', e => {
    changeClass(e.target);
});

doc.getElementById('exit').addEventListener('click', e => {
    setDisplay('fadeOut');
    fetchNUI('closeUI').then((cb) => {
        console.log('Test')
    });
});

doc.getElementById('favorite').addEventListener('click', e => changeClass(e.target));
doc.getElementById('dances').addEventListener('click', e => changeClass(e.target));
doc.getElementById('scenarios').addEventListener('click', e => changeClass(e.target));
doc.getElementById('walks').addEventListener('click', e => changeClass(e.target));
doc.getElementById('expressions').addEventListener('click', e => changeClass(e.target));
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

doc.getElementById('cancel').addEventListener('click', e => getStatus(e.target));
doc.getElementById('movement').addEventListener('click', e => getStatus(e.target));
doc.getElementById('body').addEventListener('click', e => getStatus(e.target));
doc.getElementById('loop').addEventListener('click', e => getStatus(e.target));