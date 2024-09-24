/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
import htmx from 'htmx.org';
window.htmx = htmx;
import _hyperscript from 'hyperscript.org';
_hyperscript.browserInit();

import * as AsciinemaPlayer from 'asciinema-player';
AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));

function init () {
    htmx.logger = function (elt, event, data) {
        if (console) {
            console.log(event, elt, data);
        }
    };

    // Delete 请求仍旧使用 form-encoded body 来传递参数。
    // htmx 2.0, 对于 DELETE 请求，将使用 params （根据 spec 规定）
    htmx.config.methodsThatUseUrlParams = ['get'];
    // 2.0 不允许使用 htmx 执行 cross-domain requests.
    // 取消注释来允许它正常发送请求。
    // htmx.config.selfRequestsOnly = false;
}

htmx.onLoad(init);
