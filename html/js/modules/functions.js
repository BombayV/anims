export const changeClass = target => {
    const allClass = document.getElementsByClassName('anim');
    if (target != 'all') {
        const showClass = document.getElementsByClassName(target);
        for (let i = 0; i < allClass.length; i++) {
            allClass[i].style.display = 'none';
        }
        for (let i = 0; i < showClass.length; i++) {
            showClass[i].style.display = 'flex';
        }
        return
    } else {
        for (let i = 0; i < allClass.length; i++) {
            allClass[i].style.display = 'flex';
        }
    }
}