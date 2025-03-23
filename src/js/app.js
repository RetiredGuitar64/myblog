/* eslint no-console:0 */

_hyperscript.browserInit();

// import * as AsciinemaPlayer from 'asciinema-player';
// AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));

function init () {
    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };

    // Delete 请求仍旧使用 form-encoded body 来传递参数。
    // htmx 2.0, 对于 DELETE 请求，将使用 params （根据 spec 规定）
    // 这里设定，仅仅 get 请求使用 params
    htmx.config.methodsThatUseUrlParams = ['get'];
    // 2.0 不允许使用 htmx 执行 cross-domain requests.
    // 取消注释来允许它正常发送请求。
    // htmx.config.selfRequestsOnly = false;

    copyCodeButton();
    const assetHost = IS_WATCH_MODE ? '' : 'https://assets.crystal-china.org/'

    // 确保下面的函数，只在 body 重新改变时才触发
    if (event.detail.elt.nodeName == "BODY") {
        stork.initialize(`${assetHost}${mixManifest['/docs/stork.wasm'] ?? '/docs/stork.wasm'}`);
        stork.downloadIndex(
            "docs",
            `${assetHost}${mixManifest['/docs/index.st'] ?? '/docs/index.st'}`
        );
    }

    let stork_container = document.querySelector("input[data-stork='docs']");
    if (stork_container != null) {
        stork.attach("docs");
    }
}

htmx.onLoad(init);
