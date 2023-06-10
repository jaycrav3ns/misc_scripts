import speech_recognition as sr
import pyttsx3
import pywhatkit
import datetime
import wikipedia

listener = sr.Recognizer()
engine = pyttsx3.init()
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[1].id)

def talk(text):
    engine.say(text)
    engine.runAndWait()

def take_command():
    try:
        with sr.Microphone() as source:
            print('Listening...')
            listener.adjust_for_ambient_noise(source)
            voice = listener.listen(source, timeout=5)
            command = listener.recognize_google(voice)
            command = command.lower()
            if 'assist' in command:
                command = command.replace('lexina', '') # Adjusted to lowercase 'lexina'
                print(command)
            else:
                command = None
    except sr.RequestError:
        print('Speech recognition service unavailable')
        command = None
    except sr.UnknownValueError:
        print('Unable to recognize speech')
        command = None
    return command

def run_lexina():
    command = take_command()
    if command:
        print(command)
        if 'play' in command:
            song = command.replace('play', '')
            talk('Playing ' + song)
            pywhatkit.playonyt(song)
        elif 'time' in command:
            current_time = datetime.datetime.now().strftime('%I:%M %p')
            talk('The current time is ' + current_time)
        elif 'search wikipedia for' in command:
            person = command.replace('search wikipeda for', '')
            info = wikipedia.summary(person, 1)
            print(info)
            talk(info)
        else:
            talk('Please repeat the command.')
    else:
        print('No command received.')

while True:
    run_lexina()
