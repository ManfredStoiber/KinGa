from uuid import uuid1

from paho.mqtt import client as mqtt_client

broker = 'test.mosquitto.org'
topic = 'watch_students'
client_id = f'django_client_{str(uuid1())}'

def connect_mqtt() -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id=client_id)
    client.on_connect = on_connect
    client.connect(broker)
    return client

def publish(client, msg):
    result = client.publish(topic, msg)
    status = result[0]
    if status == 0:
        print(f"Send `{msg}` to topic `{topic}`")
    else:
        print(f"Failed to send message to topic {topic}")

def run():
    client = connect_mqtt()
