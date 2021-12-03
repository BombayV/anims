// All favorites will be sotred in favoriteAnims

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
    let exists = false;
    if (elemId) {
        const id = JSON.parse(localStorage.getItem('favoriteAnims'));
        for (let i = 0; i < id.length; i++) {
            if (id[i] == elemId) {
                exists = true
            }
        }
    }
    return exists;
}

export const createPanels = (panelData) => {
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

            block.id = panel.id
            block.setAttribute('data-dances', (panel.dances) ? (JSON.stringify({dict: panel.dances.dict, anim: panel.dances.anim})) : null);
            block.setAttribute('data-scenarios', (panel.scenarios) ? (JSON.stringify({sex: panel.scenarios.sex, scene: panel.scenarios.scene})) : b);
            block.setAttribute('data-expressions', (panel.expressions) ? (JSON.stringify({expressions: panel.expressions.expression})) : b);
            block.setAttribute('data-walks', (panel.walks) ? (JSON.stringify({style: panel.walks.style})) : b);
            block.setAttribute('data-props', (panel.props) ? (JSON.stringify({prop: panel.props.prop, propBone: panel.props.propBone, propPlacement: panel.props.propPlacement, propTwo: panel.props.propTwo || null, propTwoBone: panel.props.propTwoBone || null, propTwoPlacement: panel.props.propTwoPlacement || null})): null);
            block.setAttribute('data-particles', (panel.particles) ? (JSON.stringify({asset: panel.particles.asset, name: panel.particles.name, placement: panel.particles.placement})) : null);

            star.addEventListener('click', e => {
                const isSaved = getFavorite(block.id);
                const favs = JSON.parse(localStorage.getItem('favoriteAnims'));
                if (isSaved) {
                    e.target.style.color = '#999999';
                    for (let i = 0; i < favs.length; i++) {
                        if (favs[i] == block.id) {
                            favs.splice(i, 1);
                            localStorage.setItem('favoriteAnims', JSON.stringify(favs))
                        }
                    }
                } else {
                    favs.push(block.id)
                    localStorage.setItem('favoriteAnims', JSON.stringify(favs))
                    e.target.style.color = '#f7ca17';
                }
            });

            setText(title, panel.title);
            setText(subtitle, panel.subtitle);

            textBlock.append(title, subtitle);
            block.append(textBlock, star);
            main.appendChild(block);
        }
    });
}