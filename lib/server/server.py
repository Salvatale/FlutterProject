from flask import Flask, json, request, jsonify
from chatbot import process_input
from mail_chatbot import send_email
import vector_db_maker as vector
import directory_manager as dm

app = Flask(__name__)

@app.route('/upload', methods=['OPTIONS', 'POST'])
async def upload_file():
    if request.method == 'OPTIONS':
        # Gestisci la richiesta OPTIONS
        response = app.make_default_options_response()
        # Aggiungi i metodi consentiti nella risposta
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        # Aggiungi gli header consentiti nella risposta
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    elif request.method == 'POST':
        
        directory_name = "./data/"

        if 'jsonFile' in request.files :
            json_data = request.files['jsonFile'].read()

            json_dict = json.loads(json_data)

            directory_name += json_dict['userID'] + '/' + json_dict['directory_name']

        if 'files' not in request.files:
            return jsonify({'error': 'No file part'}), 400
        
        uploaded_files = request.files.getlist("files")
        file_names = []
        for file in uploaded_files:
            file.save(file.filename)
            file_names.append(file.filename)

        await vector.get_text(uploaded_files, directory_name)
        
        response = jsonify({'message': 'Files uploaded successfully', 'files': file_names})

    # Aggiungi gli header CORS alla risposta per consentire le richieste da origini diverse
    response.headers['Access-Control-Allow-Origin'] = '*'  # Cambia '*' con l'origine desiderata
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return response

@app.route('/create_directory', methods=['OPTIONS', 'POST'])
def handle_create_directory():
    if request.method == 'OPTIONS':
        # Gestisci la richiesta OPTIONS
        response = app.make_default_options_response()
        # Aggiungi i metodi consentiti nella risposta
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        # Aggiungi gli header consentiti nella risposta
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    elif request.method == 'POST':
        # Gestisci la richiesta POST
        data = request.json  # Ottieni i dati JSON dalla richiesta
        # Fai qualcosa con i dati ricevuti, ad esempio, restituisci una risposta

        user_id = data['userId']
        
        dm.create_user_directory(user_id)

        response = jsonify({'message': "user directory created"})
        
    else:
        # Se il metodo non è OPTIONS o POST, restituisci un errore
        response = jsonify({'error': 'Metodo non supportato'})
        response.status_code = 405  # Metodo non consentito

    # Aggiungi gli header CORS alla risposta per consentire le richieste da origini diverse
    response.headers['Access-Control-Allow-Origin'] = '*'  # Cambia '*' con l'origine desiderata
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return response

@app.route('/directory', methods=['OPTIONS', 'POST'])
def handle_request_directory():
    if request.method == 'OPTIONS':
        # Gestisci la richiesta OPTIONS
        response = app.make_default_options_response()
        # Aggiungi i metodi consentiti nella risposta
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        # Aggiungi gli header consentiti nella risposta
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    elif request.method == 'POST':
        # Gestisci la richiesta POST
        data = request.json  # Ottieni i dati JSON dalla richiesta
        # Fai qualcosa con i dati ricevuti, ad esempio, restituisci una risposta

        user_id = data['userId']
        
        directory_list = dm.get_user_directory(user_id)

        response = jsonify({'directory_list': directory_list})
        
    else:
        # Se il metodo non è OPTIONS o POST, restituisci un errore
        response = jsonify({'error': 'Metodo non supportato'})
        response.status_code = 405  # Metodo non consentito

    # Aggiungi gli header CORS alla risposta per consentire le richieste da origini diverse
    response.headers['Access-Control-Allow-Origin'] = '*'  # Cambia '*' con l'origine desiderata
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return response

@app.route('/', methods=['OPTIONS', 'POST'])
def handle_request():
    if request.method == 'OPTIONS':
        # Gestisci la richiesta OPTIONS
        response = app.make_default_options_response()
        # Aggiungi i metodi consentiti nella risposta
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        # Aggiungi gli header consentiti nella risposta
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    elif request.method == 'POST':
        # Gestisci la richiesta POST
        data = request.json  # Ottieni i dati JSON dalla richiesta
        # Fai qualcosa con i dati ricevuti, ad esempio, restituisci una risposta

        path_directory = "./data/" + data['userId'] + "/" + data['context']
        
        response_data = process_input(data['message'],path_directory)



        if data['function'] == 'message':
            response = jsonify({'message': response_data})
        elif data['function'] == 'mail':
            send_email(response_data,data['mail'],data['message'])
            response = jsonify({'message': 'mail sent'})
    else:
        # Se il metodo non è OPTIONS o POST, restituisci un errore
        response = jsonify({'error': 'Metodo non supportato'})
        response.status_code = 405  # Metodo non consentito

    # Aggiungi gli header CORS alla risposta per consentire le richieste da origini diverse
    response.headers['Access-Control-Allow-Origin'] = '*'  # Cambia '*' con l'origine desiderata
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return response

@app.route('/url', methods=['OPTIONS', 'POST'])
async def handle_url_request():
    if request.method == 'OPTIONS':
        # Gestisci la richiesta OPTIONS
        response = app.make_default_options_response()
        # Aggiungi i metodi consentiti nella risposta
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        # Aggiungi gli header consentiti nella risposta
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    elif request.method == 'POST':
        # Gestisci la richiesta POST
        data = request.json  # Ottieni i dati JSON dalla richiesta
        # Fai qualcosa con i dati ricevuti, ad esempio, restituisci una risposta

        path_directory = "./data/" + data['userId'] + "/" + data['context']
        
        urls = str(data["message"])
        print(urls)

        await vector.urls_vectordb_maker(urls,path_directory)

        response = jsonify({'message': "Vectordb created successfully"})
        
    else:
        # Se il metodo non è OPTIONS o POST, restituisci un errore
        response = jsonify({'error': 'Metodo non supportato'})
        response.status_code = 405  # Metodo non consentito

    # Aggiungi gli header CORS alla risposta per consentire le richieste da origini diverse
    response.headers['Access-Control-Allow-Origin'] = '*'  # Cambia '*' con l'origine desiderata
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return response


if __name__ == '__main__':
    app.run(debug=True,port=8000)
