import smtplib
from email.mime.text import MIMEText

def send_email(response,receiver_mail,question):
        
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()

        server.login("alle.salva7@gmail.com","xejnspgcimbiqcqc")
        
        text = "Question: " + question + "\n" + "Risposta: " + response
        
        msg = MIMEText(text, _charset='utf-8')

        msg['From'] = "alle.salva7@gmail.com"
        msg['To'] = receiver_mail
        msg['Subject'] = "CHATBOT response"

        server.sendmail(msg['From'],msg['To'],msg.as_string())
        server.quit()


