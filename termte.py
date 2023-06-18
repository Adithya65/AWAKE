import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from sklearn.metrics import confusion_matrix
from keras.utils.np_utils import to_categorical
from sklearn.utils import class_weight
import warnings
import tensorflow as tf
import numpy as np
import datetime
import librosa
import os
import pyaudio
import wave
import scipy.io.wavfile as wav
import numpy as np
import time
import warnings
warnings.filterwarnings("ignore")


import os
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import array
model = tf.keras.models.load_model('snoring_local.h5', compile=False)
new_audio_file_path = 'my_padded_wave_file.wav'
state=0
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

count=0
arr=[]
limit=0
timestamp=list()
start_time = time.time()
def preprocess_audio(file_path):
    y, sr = librosa.load(file_path)
    spectrogram = librosa.feature.melspectrogram(y=y, sr=sr)
    spectrogram = librosa.power_to_db(spectrogram, ref=np.max)
    spectrogram = np.expand_dims(spectrogram, axis=-1)
    return spectrogram

def predict():
    new_spectrogram = preprocess_audio(new_audio_file_path)
    prediction = model.predict(np.array([new_spectrogram]))
    if prediction[0][0] > 0.2:
        print('The audio file contains snoring.',prediction)
        state=1
        current_time = datetime.datetime.now().time()
        current_time_str = current_time.strftime("%H:%M:%S.%f")  # Format the time as a string
        current_time_arr = current_time_str.split(":")
        timestamp.append(current_time_arr[0:2])
        arr.append(state)
    else:
        print('The audio file does not contain snoring.',prediction)
        state=0
        arr.append(state)
while True:

    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 44100
    CHUNK = 1024
    RECORD_SECONDS = 1
    WAVE_OUTPUT_FILENAME = "output.wav"


    audio = pyaudio.PyAudio()

    stream = audio.open(format=FORMAT, channels=CHANNELS,
                    rate=RATE, input=True,
                    frames_per_buffer=CHUNK)

    frames = []

    for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)

    stream.stop_stream()
    stream.close()
    audio.terminate()

    wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(audio.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    wf.writeframes(b''.join(frames))
    wf.close()

    # Read the wave file
    sample_rate, data = wav.read('output.wav')

    # Calculate the current number of frames
    num_frames = len(data)

    # Calculate the number of frames to add
    frames_to_add = 44100 - num_frames

    # Create a zero-filled array with the same number of channels
    padding = np.zeros((frames_to_add, 44032))
    z=np.zeros(padding.shape[0])
    # Concatenate the padding with the original data
    padded_data = np.concatenate((data,z), axis=0)

    # Write the padded data to a new wave file
    wav.write('my_padded_wave_file.wav', sample_rate, padded_data)
    preprocess_audio('my_padded_wave_file.wav')
    predict()
    limit=limit+1
    if (limit==10):
        end_time = time.time()
        break
ttime=end_time - start_time

ftime = round(ttime, 2)
av=ftime/len(arr)

for i in arr:
    if i ==1:
        count=count+1
count*av

k=1

lim=186
sl=0
h5file="best_model.h5"

loaded_model = tf.keras.models.load_model(h5file, compile=False) 

# define scope and credentials
scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name('awake-378606-b74d85534598.json', scope)

# authorize and open the sheet
client = gspread.authorize(creds)
sheet = client.open("awakearr")
worksheet = sheet.get_worksheet(0) # get the first sheet
worksheet.update_cell(1, 12, str(count*av))
for j in range(len(timestamp)):
    x=timestamp[j][1]
    y=timestamp[j][0]
    worksheet.update_cell(j+2, 12,y+':'+x)
    



while True:
    while '-1.00' in worksheet.col_values(2)[sl:lim]:
        print("waititing",lim)
        
        time.sleep(4)

    # read the first 186 values from the second column
    column_values = worksheet.col_values(2)[sl:lim]
    sl=lim
    lim= lim+186
    

    # convert column values to an array of integers
    column_array = array.array('f', map(float, column_values))
    import numpy as np

    # create a NumPy array from the list
    x_array = np.array(column_array)

    # reshape the array
    x_reshaped = x_array.reshape(-1, 186, 1)
    y_predict=loaded_model.predict(x_reshaped)
    y_pred_inv = np.argmax(y_predict, axis=1)
    
    if 0 in y_pred_inv:
        print("Non-ecotic beats detected")
        n=0
        worksheet.update_cell(1, 1, str(1))
        
    elif 1 in y_pred_inv:
        print("Supraventricular ectopic beats detected")
        n=1
        worksheet.update_cell(2, 1, str(1))
        

    elif 2 in y_pred_inv:
        print("Ventricular ectopic beats detected")
        n=2
        worksheet.update_cell(3, 1, str(1))
        
    elif 3 in y_pred_inv:
        print("Fusion Beats detected")
        n=3
        worksheet.update_cell(4, 1, str(1))
        
    elif 4 in y_pred_inv:
        print("Unknown Beats detected")
        n=4
        worksheet.update_cell(5, 1, str(1))
        
    
   

print("Success")
