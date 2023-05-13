import numpy as np
import argparse
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import serial
import time
line=[]
i=1

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
print("Connection Established")
ser.reset_input_buffer()
 
# define the scope
scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']

# add credentials to the account
creds = ServiceAccountCredentials.from_json_keyfile_name('INDECjson.json', scope)
client = gspread.authorize(creds)
sheet = client.open('awakerpi')


# get the first sheet of the Spreadsheet
sheet_instance = sheet.get_worksheet(0)

sheet_0 = sheet.get_worksheet(0)
sheet_1 = sheet.get_worksheet(1)



    

     




while True:
    if ser.in_waiting > 0:
            indexa='M'+str(i)
            indexb='N'+str(i)
            indexc='O'+str(i)
            indexd='P'+str(i)
            indexe='Q'+str(i)
            indexf='R'+str(i)
            indexg='S'+str(i)
            indexh='T'+str(i)
            indexb_='N'+str(1)
            indexc_='O'+str(1)
            indexd_='P'+str(1)
            indexe_='Q'+str(1)
            indexf_='R'+str(1)
            indexg_='S'+str(1)
            indexh_='T'+str(1)
            indexa_='M'+str(1)



            line = ser.readline().decode('utf-8').rstrip()
            print(line) 
            dl=line.split(",")
            print(dl)
            if (dl[0]=='ID read'):
                print("initializing")
                continue
            
            sheet_0.update_acell(indexa,dl[0])
            sheet_0.update_acell(indexb,dl[1])
            sheet_0.update_acell(indexc,dl[2])
            sheet_0.update_acell(indexd,dl[3])
            sheet_0.update_acell(indexe,dl[4])
            sheet_0.update_acell(indexf,dl[5])
            sheet_0.update_acell(indexg,dl[6])
            sheet_0.update_acell(indexh,dl[7])
            sheet_1.update_acell(indexa_,dl[0])
            sheet_1.update_acell(indexb_,dl[1])
            sheet_1.update_acell(indexc_,dl[2])
            sheet_1.update_acell(indexd_,dl[3])
            sheet_1.update_acell(indexe_,dl[4])
            sheet_1.update_acell(indexf_,dl[5])
            sheet_1.update_acell(indexg_,dl[6])
            sheet_1.update_acell(indexh_,dl[7])

            
          
            
            i=i+1
            print(dl[1])
            time.sleep(5)

