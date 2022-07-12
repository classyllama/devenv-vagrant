import time

# give some time for opensearch warm up
time.sleep(30)

# check if socket is listening
def test_listening_socket(host):
    listening = host.socket.get_listening_sockets()
    for spec in (
      "tcp://127.0.0.1:9200",
    ):
        socket = host.socket(spec)
        assert socket.is_listening

# check if service is running and enabled
def test_service(host):
    opensearch = host.service("opensearch")
    assert opensearch.is_enabled
    assert opensearch.is_running
