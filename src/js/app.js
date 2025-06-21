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
    }
}

htmx.onLoad(init);

// Set up blocks on the initial page load
document.addEventListener("DOMContentLoaded", function () {
    let textareas = document.body.querySelectorAll("textarea");
    textareas.forEach(pasteImage);

    let blocks = document.body.querySelectorAll("pre.b");
    blocks.forEach(copyCodeButton);

    setupLogo();

    initStork();
    setupStork();
});

const assetHost = IS_WATCH_MODE ? "" : "https://assets.crystal-china.org";

// Set up any newly added block (hx-boosted navigations or hx-get/hx-post/etc. swaps)
document.body.addEventListener("htmx:afterSwap", function (event) {
    let textareas = event.detail.elt.querySelectorAll("textarea");
    textareas.forEach(pasteImage);

    let blocks = event.detail.elt.querySelectorAll("pre.b");
    blocks.forEach(copyCodeButton);

    setupLogo();

    setupStork();

    // If it's possible that a block is at the top level of the response, you'll want to check the root elt itself
    if (event.detail.elt.matches("#textarea")) {
        pasteImage(event.detail.elt);
    }
});

function setupLogo() {
    const startLogoAnimation = function () {
        const canvas = document.getElementById("logo-canvas");
        var model = new Viewer3D(canvas);
        model.shader("flat", 255, 255, 255);
        model.insertModel(
            `${assetHost}${mixManifest["/assets/icosahedron.xml"] ?? "/assets/icosahedron.xml"}`,
        );
        model.contrast(0.9);
    };

    const setIPhoneDataAttribute = function () {
        let platform = navigator?.userAgent || navigator?.platform || "unknown";

        if (/iPhone/.test(platform)) {
            document.documentElement.dataset.uaIphone = true;
        }
    };

    let logoCanvas = document.getElementById("logo-canvas");

    if (logoCanvas != null) {
        setIPhoneDataAttribute();
        startLogoAnimation();
    }
}

function setupStork() {
    let storkContainer = document.querySelector("input[data-stork='docs']");
    if (storkContainer != null) {
        stork.attach("docs");
    }
}

function initStork() {
    stork.initialize(
        `${assetHost}${mixManifest["/docs/stork.wasm"] ?? "/docs/stork.wasm"}`,
    );
    stork.downloadIndex(
        "docs",
        `${assetHost}${mixManifest["/docs/index.st"] ?? "/docs/index.st"}`,
    );
}
