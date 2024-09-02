/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
import 'htmx.org';
window.htmx = require('htmx.org');
import _hyperscript from 'hyperscript.org';
_hyperscript.browserInit();

function init () {
    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };
}

htmx.onLoad(function (target) {
    init();
});
