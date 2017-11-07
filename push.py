import time
from apns import APNs, Frame, Payload

apns = APNs(use_sandbox=True, cert_file='pushcert.pem', enhanced=True)


# Send an iOS 10 compatible notification
token_hex = "redacted for github"
payload = Payload(alert="Hello World!", sound="default", badge=1, mutable_content=True)
apns.gateway_server.send_notification(token_hex, payload)
