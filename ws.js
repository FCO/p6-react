var loc = window.location, new_uri;
if (loc.protocol === "https:") {
    new_uri = "wss:";
} else {
    new_uri = "ws:";
}
new_uri += "//" + loc.host;
new_uri += "/ws";
window.ws = new WebSocket(new_uri);
window.ws.onopen = function () {
    console.log("opened");
}
window.ws.onmessage = function (msg) {
    console.log(`received: ${msg.data}`);
    document.body.innerHTML = msg.data;
}

function sendToProact(name, event) {
    event.preventDefault();
    console.log(`sending: ${name}, ${event}`);
    window.ws.send(JSON.stringify({func: name, event: event}))
}
