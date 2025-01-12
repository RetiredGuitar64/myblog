/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
import htmx from 'htmx.org';
window.htmx = htmx;
import _hyperscript from 'hyperscript.org';
_hyperscript.browserInit();

import * as AsciinemaPlayer from 'asciinema-player';
// AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));

function copyCodeButton () {
    const copyButtonLabel = "Copy Code";

    // use a class selector if available
    let blocks = document.querySelectorAll("pre.b");

    blocks.forEach((block) => {
        // only add button if browser supports Clipboard API
        if (navigator.clipboard) {
            let button = document.createElement("button");
            button.className = "copyBtn";

            button.innerText = copyButtonLabel;

            block.prepend(button);

            button.addEventListener("click", async () => {
                await copyCode(block, button);
            });
        }
    });

    async function copyCode(block, button) {
        let code = block.querySelector("code");
        let text = code.innerText;

        await navigator.clipboard.writeText(text);

        button.innerText = "Code Copied";

        setTimeout(() => {
            button.innerText = copyButtonLabel;
        }, 1500);
    }
}

function init () {
    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };

    // console.log("111111111111111");

    // Delete 请求仍旧使用 form-encoded body 来传递参数。
    // htmx 2.0, 对于 DELETE 请求，将使用 params （根据 spec 规定）
    htmx.config.methodsThatUseUrlParams = ['get'];
    // 2.0 不允许使用 htmx 执行 cross-domain requests.
    // 取消注释来允许它正常发送请求。
    // htmx.config.selfRequestsOnly = false;

    // setIPhoneDataAttribute();
    // startLogoAnimation();
    copyCodeButton();
}

htmx.onLoad(init);
