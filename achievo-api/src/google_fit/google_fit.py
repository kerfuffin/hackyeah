from datetime import timedelta, datetime
from typing import List
import httplib2
from apiclient.discovery import build
from oauth2client import tools
from oauth2client.client import OAuth2WebServerFlow
from oauth2client.file import Storage
from enum import Enum


class GFitDataType(Enum):
    WEIGHT = ('com.google.weight', float, 'fpVal')
    STEPS = ('com.google.step_count.delta', int, 'intVal')
    SLEEP = ('com.google.sleep.segment', int, 'intVal')
    CALORIES = ('com.google.calories.expended', float, 'fpVal')


class GoogleFit:
    """
    Manages the service to access your Google Fit account data.
    """

    _AUTH_SCOPES = [
        'https://www.googleapis.com/auth/fitness.body.read',
        'https://www.googleapis.com/auth/fitness.activity.read',
        'https://www.googleapis.com/auth/fitness.nutrition.read',
        'https://www.googleapis.com/auth/fitness.sleep.read',
    ]

    def __init__(self, client_id: str, client_secret: str):
        """
        :param client_id: Your Google client ID
        :param client_secret: Your Google client secret
        """
        self._client_id = client_id
        self._client_secret = client_secret
        self._service = None

    def authenticate(self, auth_scopes: List[str] = None, credentials_file: str = '.google_fit_credentials'):
        """
        Authenticate and give access to Google auth scopes. If no valid credentials file is found, a browser will open
        requesting access.
        :param auth_scopes: [optional] Google auth scopes
        :param credentials_file: [optional] Path to credentials file
        """
        if auth_scopes is None:
            auth_scopes = self._AUTH_SCOPES

        flow = OAuth2WebServerFlow(self._client_id, self._client_secret, auth_scopes)
        storage = Storage(credentials_file)
        credentials = storage.get()

        if credentials is None or credentials.invalid:
            credentials = tools.run_flow(flow, storage)
        http = httplib2.Http()
        http = credentials.authorize(http)
        self._service = build('fitness', 'v1', http=http)

    def _execute_aggregate_request(self, data_type: str, start_date: datetime, end_date: datetime):
        def to_epoch(dt: datetime) -> int:
            return int(dt.timestamp()) * 1000

        body = {
            "aggregateBy": [{"dataTypeName": data_type}],
            "endTimeMillis": str(to_epoch(end_date)),
            "startTimeMillis": str(to_epoch(start_date)),
        }
        return self._service.users().dataset().aggregate(userId='me', body=body).execute()

    @staticmethod
    def _extract_points(resp: dict):
        try:
            return resp['bucket'][0]['dataset'][0]['point']
        except (KeyError, IndexError):
            return []

    @staticmethod
    def _count_total(data_type: GFitDataType, resp: dict):
        cum = 0
        points = GoogleFit._extract_points(resp)

        if len(points) == 0:
            return 'no data found'
        for point in points:
            cum += data_type.value[1](point['value'][0][data_type.value[2]])

        if data_type == GFitDataType.WEIGHT:
            return cum / len(points)
        else:
            return cum

    def _avg_for_response(self, data_type, begin, end):
        response = self._execute_aggregate_request(data_type.value[0], begin, end)
        return self._count_total(data_type, response)

    def average_today(self, data_type: GFitDataType):
        """
        :param data_type: A data type from GFitDataType
        :return: the average for the specified datatype for today up to now
        """
        begin_today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        end_today = begin_today + timedelta(days=1)
        return self._avg_for_response(data_type, begin_today, end_today)

    def total_calories_burned_today(self):
        """
        Returns the total calories burned today.
        """
        return self.average_today(GFitDataType.CALORIES)

    def total_sleep_duration_today(self):
        """
        Returns the total sleep duration in hours for today.
        """
        sleep_data = self.average_today(GFitDataType.SLEEP)
        if isinstance(sleep_data, str):  # Check if there's no data found
            return sleep_data
        return sleep_data / (1000 * 60 * 60)  # Convert from milliseconds to hours

    def get_all_data_today(self):
        """
        Retrieves all data types for today.
        """
        data = {}
        data['steps'] = self.average_today(GFitDataType.STEPS)
        data['weight'] = self.average_today(GFitDataType.WEIGHT)
        data['calories'] = self.total_calories_burned_today()
        data['sleep_hours'] = self.total_sleep_duration_today()
        return data
