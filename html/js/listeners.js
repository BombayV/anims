import { changeClass } from "./modules/functions.js";

const doc = document;

doc.getElementById('home').addEventListener('click', e => {
    changeClass('all');
});

doc.getElementById('favorite').addEventListener('click', e => changeClass(e.target.id));
doc.getElementById('dances').addEventListener('click', e => changeClass(e.target.id));
doc.getElementById('scenarios').addEventListener('click', e => changeClass(e.target.id));
doc.getElementById('walks').addEventListener('click', e => changeClass(e.target.id));
doc.getElementById('expressions').addEventListener('click', e => changeClass(e.target.id));
doc.getElementById('shared').addEventListener('click', e => changeClass(e.target.id));