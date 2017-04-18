DotSnap
=======

DotSnap helps you to finally see your beautiful desktop wallpaper again. Quickly change your default screenshot folder where ever you are, as well as give your screenshots a real name even before you take them to stay organized. 

- Set your default folder once, or change it as often as you want with quick access in your top bar. 

- Give your screenshots a default prefix name, or change it as often as you want. We even save your 5 last used names. Optional add a date stamp to it.

Read more about it & See how it works:
http://bit.ly/1qeoMZr

## Installation

- Open a terminal prompt and execute:

`$ git clone --recursive https://github.com/DotMail/DotSnap.git ; cd DotSnap ;  git submodule update -i --recursive`

- After git finishes pulling all of the project's dependencies, open the provided Xcode project and click Run.
- Profit

## Known Issues

- 1. For users using CloudApp: If CloudApp auto-upload is active, CloudApp sometimes uploads broken screenshots because DotSnap already moved the screenshot into a different folder. Since CloudApp became very slow since the past few months, this issue occurs more often than expected.


- 2. Since Dropbox introduced an option to move screenshots automatically to your Dropbox folder, DotSnap runs into some issues here as well.
 

## How DotSnap works
DotSnap works in the background and is compatible with your default Mac screenshot shortcut. It essentially just moves your files to the folder you set inside DotSnap as well as renames the file according to your setting in DotSnap. If you haven't activated the TimeStamp option, files with the same name will get a unique number added to the end.

## Contact
If you have any questions, comments, or want to contribute, you can reach us on Twitter [@CodaFi_](https://twitter.com/CodaFi_) and [@schneidertobias](https://twitter.com/schneidertobias)

## Download latest Build here (if you just want to install it)
https://github.com/DotMail/DotSnap/releases/tag/1.0

