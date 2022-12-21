require.config({
    paths: {
        mermaid: "https://cdnjs.cloudflare.com/ajax/libs/mermaid/9.3.0/mermaid.min.js"
    }
});
require(['mermaid'], function(mermaid) { mermaid.init() });