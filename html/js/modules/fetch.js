// All favorites will be sotred in favoriteAnims

const doc = document;
const resourceName = window.GetParentResourceName ? GetParentResourceName () : 'anims';

export const fetchNUI = async (cbname, data) => {
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    };
    const resp = await fetch(`https://${resourceName}/${cbname}`, options);
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
    const old = localStorage.getItem('oldValues');
    if (old != null) {
        if (old != JSON.stringify(panelData)) {
            console.log('You seem to have new animations. Remember to open a pull request on Github so people can enjoy more animations.\nhttps://github.com/BombayV/anims')
            localStorage.setItem('oldValues', JSON.stringify(panelData))
        }
    } else {
        localStorage.setItem('oldValues', JSON.stringify(panelData))
    }
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

            block.id = (panel.dances && panel.dances.dict) || (panel.scenarios && panel.scenarios.scene) || (panel.expressions && panel.expressions.expression) || (panel.walks && panel.walks.style)
            block.setAttribute('data-dances', (panel.dances) ? (JSON.stringify({dict: panel.dances.dict, anim: panel.dances.anim, duration: panel.dances.duration})) : false);
            block.setAttribute('data-scenarios', (panel.scenarios) ? (JSON.stringify({sex: panel.scenarios.sex, scene: panel.scenarios.scene})) : false);
            block.setAttribute('data-expressions', (panel.expressions) ? (JSON.stringify({expressions: panel.expressions.expression})) : false);
            block.setAttribute('data-walks', (panel.walks) ? (JSON.stringify({style: panel.walks.style})) : false);
            block.setAttribute('data-props', (panel.props) ? (JSON.stringify({prop: panel.props.prop, propBone: panel.props.propBone, propPlacement: panel.props.propPlacement, propTwo: panel.props.propTwo || false, propTwoBone: panel.props.propTwoBone || false, propTwoPlacement: panel.props.propTwoPlacement || false})): false);
            block.setAttribute('data-particles', (panel.particles) ? (JSON.stringify({asset: panel.particles.asset, name: panel.particles.name, placement: panel.particles.placement, rgb: panel.particles.rgb})) : false);
            block.setAttribute('data-shared', (panel.shared) ? (JSON.stringify({first: panel.shared.first, second: panel.shared.second})) : false);
            block.setAttribute('data-disableMovement', (panel.disableMovement) ? (JSON.stringify({disableMovement: panel.disableMovement})) : false);
            block.setAttribute('data-disableLoop', (panel.disableLoop) ? (JSON.stringify({disableLoop: panel.disableLoop})) : false);

            star.addEventListener('click', e => {
                const isSaved = getFavorite(block.id);
                const favs = JSON.parse(localStorage.getItem('favoriteAnims'));
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
                if (e.target.textContent != 'bookmark_add') {
                    fetchNUI('beginAnimation', {dance: JSON.parse(block.getAttribute('data-dances')), scene: JSON.parse(block.getAttribute('data-scenarios')), expression: JSON.parse(block.getAttribute('data-expressions')), walk: JSON.parse(block.getAttribute('data-walks')), prop: JSON.parse(block.getAttribute('data-props')), particle: JSON.parse(block.getAttribute('data-particles')), shared: JSON.parse(block.getAttribute('data-shared')), disableMovement: JSON.parse(block.getAttribute('data-disableMovement')), disableLoop: JSON.parse(block.getAttribute('data-disableLoop'))}).then((resp) => {
                        (resp.e)
                            ? fetchNUI('sendNotification', {type: 'success', message: 'Animation started!'})
                            : fetchNUI('sendNotification', {type: 'error', message: 'Animation could not load!'});
                        return;
                    })
                    block.classList.add('pop');
                    setTimeout(() => {
                        block.classList.remove('pop');
                    }, 300);
                }
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
