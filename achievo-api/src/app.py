from flask import Flask, request, jsonify
from config import Config
from google_fit import GoogleFit
from oauth2client.client import OAuth2Credentials
import requests

app = Flask(__name__)
app.config.from_object(Config)


def validate_token(token):
    response = requests.get(
        'https://www.googleapis.com/oauth2/v1/tokeninfo',
        params={'access_token': token}
    )
    return response.status_code == 200


@app.route('/data', methods=['POST'])
def get_data():
    # Extract the token from the request body
    data = request.get_json()
    if not data or 'token' not in data:
        return jsonify({'error': 'Token is required in the request body'}), 400

    token = data['token']

    # Validate the token
    if not validate_token(token):
        return jsonify({'error': 'Invalid or expired token'}), 401

    # Create credentials from the token
    credentials = OAuth2Credentials(
        access_token=token,
        client_id=app.config['CLIENT_ID'],
        client_secret=app.config['CLIENT_SECRET'],
        refresh_token=None,
        token_expiry=None,
        token_uri='https://oauth2.googleapis.com/token',
        user_agent='Achievo API/1.0',
        revoke_uri='https://oauth2.googleapis.com/revoke'
    )

    # Initialize GoogleFit instance with credentials
    fit = GoogleFit(app.config['CLIENT_ID'], app.config['CLIENT_SECRET'])
    fit.authenticate_with_credentials(credentials)

    try:
        # Get data
        user_data = fit.get_all_data_today()
        return jsonify(user_data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)