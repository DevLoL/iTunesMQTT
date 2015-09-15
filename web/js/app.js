var mqtt;
var reconnectTimeout = 2000;
var host = "158.255.212.248";
var port = 8080;
var base = "devlol/h19/tomk32/music/";

function control(cmd) {
    mqtt.send(base + "control", cmd);
}

function MQTTconnect() {
    console.log("connecting");
    mqtt = new Paho.MQTT.Client(
                    host,
                    port,
                    "web_" + parseInt(Math.random() * 100,
                    10));
    var options = {
        timeout: 3,
        onSuccess: onConnect,
        onFailure: function (message) {
            setTimeout(MQTTconnect, reconnectTimeout);
        }
    };

    mqtt.onConnectionLost = onConnectionLost;
    mqtt.onMessageArrived = onMessageArrived;

    console.log("Host="+ host + ", port=" + port);
    mqtt.connect(options);
}

function onConnect() {
    console.log('Connected to ' + host + ':' + port);
    mqtt.subscribe(base + "#", {qos: 0});
}

function onConnectionLost(response) {
    setTimeout(MQTTconnect, reconnectTimeout);
    console.log("connection lost: " + response.errorMessage + ". Reconnecting");
};

function onMessageArrived(message) {

    var topic = message.destinationName;
    var payload = message.payloadString;

    console.log(topic + ' = ' + payload);

    switch (topic) {
        case base + 'playing':
            document.getElementById("playing").innerHTML = payload;            
            break;
        default:
            break;
    }
};


window.onload = function() {
    console.log("booting up");
    MQTTconnect();
};

