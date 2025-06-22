/* eslint no-console:0 */

_hyperscript.browserInit();

// import * as AsciinemaPlayer from 'asciinema-player';
// AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));

function init() {
    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };

    // Delete 请求仍旧使用 form-encoded body 来传递参数。
    // htmx 2.0, 对于 DELETE 请求，将使用 params （根据 spec 规定）
    // 这里设定，仅仅 get 请求使用 params
    htmx.config.methodsThatUseUrlParams = ["get"];
    // 2.0 不允许使用 htmx 执行 cross-domain requests.
    // 取消注释来允许它正常发送请求。
    // htmx.config.selfRequestsOnly = false;

    // 确保下面的函数，只在 body 重新改变时才触发
    if (event.detail.elt.nodeName == "BODY") {
        // 薛定谔的猫？我只要这里日志查看它，它就有数据，否则，它经常是空的？
        console.log(mixManifest);
        initStork();
    }

    eventElt = event.detail.elt;
    console.log(eventElt.nodeName);

    setupLogo();
    setupPasteImage(eventElt);
    setupCopyCodeButton(eventElt);
    setupStork(eventElt);
}

// 备忘，为什么这里不直接使用 htmx.onLoad 呢？
// https://github.com/bigskysoftware/htmx/discussions/3126#discussioncomment-11820869

//  htmx will fire htmx:load on every top-level child of the swapped content.
// When you use hx-boost, it's an equivalent to hx-target="body" hx-swap="innerHTML",
// which will replace the content of the body, then fire htmx:load on its direct descendants,
// so here the header, div and dialog from your screenshot indeed.

// 然后，为什么现在又用回了 onLoad, 因为现在经过重构，body 下面只有一个顶级的 div,
// 之前事件绑定重复激发的情况不存在了，而且，onLoad 可以很好的处理 history 相关的问题。
// 不必再单独为 htmx:historyRestore" 事件绑定一遍了。

htmx.onLoad(init);

function setupLogo() {
    const canvas = document.getElementById("logo-canvas");

    if (canvas != null) {
        // setIPhoneDataAttribute
        let platform = navigator?.userAgent || navigator?.platform || "unknown";

        if (/iPhone/.test(platform)) {
            document.documentElement.dataset.uaIphone = true;
        }

        // startLogoAnimation
        var model = new Viewer3D(canvas);
        model.shader("flat", 255, 255, 255);
        model.insertModel("/assets/icosahedron.xml");
        model.contrast(0.9);
    }
}

function setupStork(eventElt) {
    let storkContainer = eventElt.querySelector("input[data-stork='docs']");
    if (storkContainer != null) {
        stork.attach("docs");
    }
}

function initStork() {
    const assetHost = IS_WATCH_MODE ? "" : "https://assets.crystal-china.org";

    stork.initialize(
        `${assetHost}${mixManifest["/docs/stork.wasm"] ?? "/docs/stork.wasm"}`,
    );
    stork.downloadIndex(
        "docs",
        `${assetHost}${mixManifest["/docs/index.st"] ?? "/docs/index.st"}`,
    );
}

function setupCopyCodeButton(eventElt) {
    eventElt.querySelectorAll("pre.b").forEach(copyCodeButton);

    // If it's possible that a block is at the top level of the response,
    // you'll want to check the root elt itself
    if (eventElt instanceof Element) {
        if (eventElt.matches("pre.b")) {
            pasteImage(eventElt);
        }
    }
}

function setupPasteImage(eventElt) {
    eventElt.querySelectorAll("textarea").forEach(pasteImage);

    if (eventElt instanceof Element) {
        if (eventElt.matches("textarea")) {
            pasteImage(eventElt);
        }
    }
}
