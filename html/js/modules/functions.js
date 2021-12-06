export const changeClass = target => {
    const sidebar = document.getElementsByClassName('sidebar');
    for (let i = 0; i < sidebar.length; i++) {
        sidebar[i].style.color = 'white';
    }
    target.classList.add('pop');
    target.style.color = "#ff0d4ecc";
    setTimeout(() => {
        target.classList.remove('pop');
    }, 500);

    if (target.id != 'settings') {
        const allClass = document.getElementsByClassName('anim');
        if (target.id != 'home') {
            const showClass = document.getElementsByClassName(target.id);
            for (let i = 0; i < allClass.length; i++) {
                allClass[i].style.display = 'none';
            }
            for (let i = 0; i < showClass.length; i++) {
                showClass[i].style.display = 'flex';
            }
            return;
        } else {
            for (let i = 0; i < allClass.length; i++) {
                allClass[i].style.display = 'flex';
            }
        }
    } else {


    }
}

export const getStatus = elem => {
    const savedOpts = JSON.parse(localStorage.getItem('animOptions'));
    for (let i = 0; i < savedOpts.length; i++) {
        if (savedOpts[i] == elem.id) {
            savedOpts.splice(i, 1);
            localStorage.setItem('animOptions', JSON.stringify(savedOpts));
            elem.style.backgroundColor = "#000000cc";
            return true;
        }
    }
    savedOpts.push(elem.id);
    localStorage.setItem('animOptions', JSON.stringify(savedOpts));
    elem.style.backgroundColor = "#ff0d4ecc";
    return false;
}

export const setDisplay = animType => {
    let currentDisplay = (animType == 'fadeIn' && 'flex') || 'none'
    if (currentDisplay == 'flex') {
        document.querySelector('.menu-container').style.display = currentDisplay;
        document.querySelector('.anims-container').style.display = currentDisplay;
    }
    document.querySelector('.menu-container').classList.add(animType);
    document.querySelector('.anims-container').classList.add(animType);
    setTimeout(() => {
        if (currentDisplay != 'flex') {
            document.querySelector('.menu-container').style.display = currentDisplay;
            document.querySelector('.anims-container').style.display = currentDisplay;
        }
        document.querySelector('.menu-container').classList.remove(animType);
        document.querySelector('.anims-container').classList.remove(animType);
    }, 300);
}