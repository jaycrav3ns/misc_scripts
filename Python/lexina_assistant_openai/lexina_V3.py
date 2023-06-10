import speech_recognition as sr
import pyttsx3
import datetime
import wikipedia
import subprocess
import openai
import env

# Initialize speech engine
engine = pyttsx3.init()
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[1].id)

# Initialize speech recognizer
listener = sr.Recognizer()

def talk(text):
    engine.say(text)
    engine.runAndWait()

# OpenAI initialization
openai.api_key = env.OPEN_AI_KEY

def generate_response(prompt):
    discussion = openai.Completion.create(
        prompt=prompt,
        engine='text-davinci-002',
        max_tokens=512,
    )

    answer = discussion.choices[0].text

    return answer

def take_command():
    try:
        with sr.Microphone() as source:
            print('Listening...')
            listener.adjust_for_ambient_noise(source)
            voice = listener.listen(source, timeout=5)
            command = listener.recognize_google(voice)
            command = command.lower()
            if 'assist' in command:
                command = command.replace('lexina', '') # Adjusts to lowercase 'lexina'
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

def play_song(target):
    script_path = "player.sh"  # Replace with the actual path to your Bash script

    subprocess.run([script_path], input=target.encode(), text=True)

def run_lexina():
    command = take_command()
    if command:
        print(command)
        if 'play' in command:
            song = command.replace('play', '')
            talk('Now Playing ' + song)
            play_song(song)
        elif 'time' in command:
            current_time = datetime.datetime.now().strftime('%I:%M %p')
            talk('The current time is ' + current_time)
        elif 'search wikipedia for' in command:
            person = command.replace('search wikipedia for', '')
            info = wikipedia.summary(person, 1)
            print(info)
            talk(info)
        else:
            talk('Computing...')
            response = generate_response(command)
            talk(response)
    else:
        print('No command received.')

while True:
    run_lexina()
