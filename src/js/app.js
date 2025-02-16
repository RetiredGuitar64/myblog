/* eslint no-console:0 */
import htmx from 'htmx.org';
window.htmx = htmx;
import _hyperscript from 'hyperscript.org';
_hyperscript.browserInit();
import { copyCodeButton } from './copy_code_button.js';
import * as AsciinemaPlayer from 'asciinema-player';
// AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));

// import docsearch from '@docsearch/js';
// docsearch({
//     container: '#docsearch',
//     appId: 'X22A7U5SSD',
//     indexName: 'crystal-china',
//     apiKey: '02c343ec068a94b17e13b96f1b4b5a7a',
// });

function init () {
    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };

    function doTinySearch(value) {
        // Retrieve 5 results
        const results = search(value, 5);
        let ul = document.getElementById("results");
        ul.innerHTML = "";

        for (let i = 0; i < results.length; i++) {
            var li = document.createElement("li");

            let [title, url] = results[i];
            let elemlink = document.createElement('a');
            elemlink.innerHTML = title;
            elemlink.setAttribute('href', url);
            li.appendChild(elemlink);

            ul.appendChild(li);
        }
    }

    let input = document.getElementById("search-input");
    input.addEventListener('keyup', (event) => {
        const value = event.target.value;
        doTinySearch(value);
    });

    // Delete 请求仍旧使用 form-encoded body 来传递参数。
    // htmx 2.0, 对于 DELETE 请求，将使用 params （根据 spec 规定）
    // 这里设定，仅仅 get 请求使用 params
    htmx.config.methodsThatUseUrlParams = ['get'];
    // 2.0 不允许使用 htmx 执行 cross-domain requests.
    // 取消注释来允许它正常发送请求。
    // htmx.config.selfRequestsOnly = false;

    // setIPhoneDataAttribute();
    // startLogoAnimation();

    // 确保下面的函数，只在 body 重新改变时才触发
    // if (event.detail.elt.nodeName == "BODY") {
    copyCodeButton();
    // }
}

htmx.onLoad(init);
