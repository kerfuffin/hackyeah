import googleapiclient.discovery
import google_auth_oauthlib.flow
import datetime
import time

# Path to your credentials.json file
credentials_path = 'credentials.json'

# Scopes required for accessing Google Fit data
SCOPES = ['https://www.googleapis.com/auth/fitness.activity.read']

# Run local server to get the credentials
flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(credentials_path, SCOPES)
credentials = flow.run_local_server(port=0)

# Build the Google Fit service
service = googleapiclient.discovery.build('fitness', 'v1', credentials=credentials)

# Define start and end time in nanoseconds
# Example: Last 24 hours
end_time = int(time.time() * 1e9)  # Current time in nanoseconds
start_time = end_time - int(24 * 60 * 60 * 1e9)  # 24 hours ago in nanoseconds

# Correct format for data_set parameter: "startTime-in-nanoseconds-endTime-in-nanoseconds"
data_set = f"{start_time}-{end_time}"

# API request to get step count data
data_source = "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"

# Get dataset
try:
    result = service.users().dataSources().datasets().get(
        userId='me',
        dataSourceId=data_source,
        datasetId=data_set
    ).execute()
    
    # Print step count data
    if 'point' in result:
        for point in result['point']:
            start_time = int(point['startTimeNanos']) / 1e9
            end_time = int(point['endTimeNanos']) / 1e9
            steps = point['value'][0]['intVal']
            print(f"Steps: {steps}, Start Time: {datetime.datetime.fromtimestamp(start_time)}, End Time: {datetime.datetime.fromtimestamp(end_time)}")
    else:
        print("No data found for the given time range.")

    print(result)

except googleapiclient.errors.HttpError as error:
    print(f"An error occurred: {error}")
