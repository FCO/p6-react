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

const formToJSON = elements => [].reduce.call(elements, (data, element) => {

  data[element.name] = element.value;
  return data;

}, {});

function sendToProact(name, event) {
    event.preventDefault();

    let data = {
        func: name,
        event
    };

    switch(event.target.tagName) {
        case "FORM":
            data.fields = formToJSON(event.target.elements);
        break;
    }

    console.log("sending: ", data);
    window.ws.send(JSON.stringify(data))
}
