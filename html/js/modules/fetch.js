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

const getFavorite = elemId => {
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

            block.classList.add('anim', panel.type);
            star.classList.add('material-icons', 'star');
            star.textContent = 'bookmark_add';

            block.id = panel.id
            block.setAttribute('data-dances', (panel.dances) ? (JSON.stringify({dict: panel.dances.dict, anim: panel.dances.anim})) : null);
            block.setAttribute('data-scenarios', (panel.scenarios) ? (JSON.stringify({sex: panel.scenarios.sex, scene: panel.scenarios.scene})) : null);
            block.setAttribute('data-expressions', (panel.expressions) ? (JSON.stringify({expressions: panel.expressions.expression})) : null);
            block.setAttribute('data-walks', (panel.walks) ? (JSON.stringify({style: panel.walks.style})) : null);
            block.setAttribute('data-props', (panel.props) ? (JSON.stringify({prop: panel.props.prop, propBone: panel.props.propBone, propPlacement: panel.props.propPlacement, propTwo: panel.props.propTwo || null, propTwoBone: panel.props.propTwoBone || null, propTwoPlacement: panel.props.propTwoPlacement || null})): null);
            block.setAttribute('data-particles', (panel.particles) ? (JSON.stringify({asset: panel.particles.asset, name: panel.particles.name, placement: panel.particles.placement})) : null);

            star.addEventListener('click', e => {
                const isSaved = getFavorite(block.id);
                const favs = JSON.parse(localStorage.getItem('favoriteAnims'));
                console.log(favs)
                if (isSaved) {
                    for (let i = 0; i < favs.length; i++) {
                        if (favs[i] == block.id) {
                            favs.splice(i, 1);
                            localStorage.setItem('favoriteAnims', JSON.stringify(favs));
                            e.target.style.color = '#999999';
                            block.classList.remove('favorite');
                        }
                    }
                } else {
                    favs.push(block.id)
                    localStorage.setItem('favoriteAnims', JSON.stringify(favs))
                    e.target.style.color = '#FBB13C';
                    block.classList.add('favorite');
                }
            });

            block.addEventListener('click', e => {
                console.log('teast')
                fetchNUI('beginAnimation', {dance: e.target.getAttribute('data-dances'), scene: e.target.getAttribute('data-scenarios'), expression: e.target.getAttribute('data-expressions'), walk: e.target.getAttribute('data-walks'), prop: e.target.getAttribute('data-props'), particle: e.target.getAttribute('data-particles')})

                block.classList.add('pop');
                setTimeout(() => {
                    block.classList.remove('pop');
                }, 500);
            })

            setText(title, panel.title);
            setText(subtitle, panel.subtitle);

            textBlock.append(title, subtitle);
            block.append(textBlock, star);
            main.appendChild(block);
        }
    });

    const favorites = JSON.parse(localStorage.getItem('favoriteAnims'))
    const anims = document.getElementsByClassName('anim')
    for (let i = 0; i < anims.length; i++) {
        for (let x = 0; x < favorites.length; x++) {
            if (anims[i].id == favorites[x]) {
                anims[i].classList.add('favorite');
                anims[i].getElementsByTagName("span")[2].style.color = '#FBB13C';
            }
        }
    }
}