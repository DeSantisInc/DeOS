import 'babel-polyfill';

import Dog from '../common/dog';

const browserToby = new Dog('Browser Toby');

document.querySelector('.app').innerText = browserToby.bark();
