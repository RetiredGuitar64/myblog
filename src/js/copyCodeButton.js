function copyCodeButton () {
    const copyButtonLabel = "📄"

    // use a class selector if available
    let blocks = document.querySelectorAll("pre.b");

    blocks.forEach((block) => {
        // only add button if browser supports Clipboard API
        if (navigator.clipboard) {
            let button = block.querySelector("button.copyBtn");

            if (button === null) {
                button = document.createElement("button");
                button.className = "copyBtn";
                button.setAttribute("style", "background: #24273a; color: white; border: none;");
                button.innerText = copyButtonLabel;
                button.addEventListener("click", async () => {
                    await copyCode(block, button);
                });

                block.prepend(button);
            }
        }
    });

    async function copyCode(block, button) {
        let code = block.querySelector("code");
        let lineNumbers = code.querySelectorAll('span[style="user-select: none;"]');
        lineNumbers.forEach((span) => {
            span.setAttribute("style", "user-select: none; display: none;");
        })
        let text = code.innerText;
        lineNumbers.forEach((span) => {
            span.setAttribute("style", "user-select: none;");
        })

        await navigator.clipboard.writeText(text);

        button.innerText = "copied";

        setTimeout(() => {
            button.innerText = copyButtonLabel;
        }, 1500);
    }
}

export default copyCodeButton
