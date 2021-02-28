import requests as http

def send_notification(to, title, subtitle, description):

    URL = 'https://fcm.googleapis.com/fcm/send'
    SERVER_KEY = 'AAAAczj9EWs:APA91bFcJjeGAIDJoKhrpx-1t9uM7pmpvhDPFYc1MC24kwMU2dp5XL4z0HhdwPbJxioS8nDEJXvo5oJ5-6UnGICjKUPZBnriVMO0OiA1UZsoVTtxtO5Vj_1PI1qlMBiKcvmkdthC_SHF'

    headers = {"Authorization": "key={key}".format(key=SERVER_KEY)}

    body = {
        "to": to,
        "notification": {
            "title": title,
            "body": subtitle,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
        "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "arg": description
        }
    }

    response = http.post(URL, json=body, headers=headers)

    return response
