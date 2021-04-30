#!/usr/bin/python3


import bs4, requests, smtplib, re 


# Download page
getPage = requests.get('http://direktdoki.hu/index.php?option=com_comprofiler&task=userProfile&tab=50&Itemid=20&user=1311&weeknav=0')
getPage.raise_for_status() #if error it will stop the program

# Parse text for foods
menu = bs4.BeautifulSoup(getPage.text, 'html.parser')
appts = menu.select('.colored_cell')

print(len(appts))

the_one = 'borzaska'
flength = len(the_one)
available = False
dates=''
for appt in appts:
	a=appt.encode('utf-8')
	a=re.sub(r'.*opendialog...', '', str(a))
	a=re.sub(r'\\.*', '', str(a))
	print(a)
	if a.startswith( '2019-05-06' ):
		dates+=a+'\n'
		available=True

print(dates)


toAddress=['gaal.andras@gmail.com']
if available == True:
    conn = smtplib.SMTP('smtp.gmail.com', 587) # smtp address and port
    conn.ehlo() # call this to start the connection
    conn.starttls() # starts tls encryption. When we send our password it will be encrypted.
    conn.login('smsbackup.agaal@gmail.com', '*******')
    conn.sendmail('smsbackup.agaal@gmail.com', toAddress, 'Subject: Direktdoki idopont van!\n\nIdopontok:\n\n'+dates)
    conn.quit()
    print('Sent notificaton e-mails for the following recipients:\n')
    for i in range(len(toAddress)):
        print(toAddress[i])
    print('')
