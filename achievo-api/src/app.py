from flask import Flask, jsonify
from config import Config
from google_fit import GoogleFit

app = Flask(__name__)
app.config.from_object(Config)

# Initialize GoogleFit instance
fit = GoogleFit(app.config['CLIENT_ID'], app.config['CLIENT_SECRET'])
fit.authenticate(credentials_file=app.config['CREDENTIALS_FILE'])

@app.route('/data', methods=['GET'])
def get_data():
    data = fit.get_all_data_today()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
