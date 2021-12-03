const doc = document;

export const fetchNUI = async (cbname, data) => {
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    };
    const resp = await fetch(`https://anims/${cbname}`, options);
    return await resp.json();
};

const setText = (elem, text) => elem.textContent = text;

const getFavorite = (elemId) => {
    const exists = false;
    if (elemId) {
        const id = localStorage.getItem(elemId);
        (id) ? exists = true : exist = false;
    }
    return exists;
}

export const createPanels = (panelData) => {
    console.log(panelData)
    const main = doc.getElementById('anims-holder');
    panelData.forEach(panel => {
        if (panel && panel.type) {
            const block = doc.createElement('div');
            const textBlock = doc.createElement('div')
            const title = doc.createElement('span');
            const subtitle = doc.createElement('span');
            const star = doc.createElement('span');

            block.classList.add('anim');
            star.classList.add('material-icons', 'star');
            star.textContent = 'star';

            star.addEventListener('click', e => {
                const isSaved =
                e.target.style.color = 'yellow';
            });

            setText(title, panel.title);
            setText(subtitle, panel.subtitle);

            textBlock.append(title, subtitle);
            block.append(textBlock, star);
            main.appendChild(block);
        }
    });
}