# Frei3 Video Downloader (inoffiziell)
VideoDownloader für hochgeladene Videos auf frei3

Das hier ist ein von der Medienplattform frei3 unabhängiges Programm um Videos dort herunterladen zu können, also auf eigene Gefahr ;)

### Programm bauen

Das Programm wurde in Free Pascal mit der IDE Lazarus geschrieben und ist unter allen Betriebssystemen kompillierbar, die auch von Lazarus unterstützt werden. Eventuell müssen lediglich die ffmpeg-Aufrufe angepasst werden. Nach der Installation der Lazarus IDE, welche hier: https://www.lazarus-ide.org/index.php gefunden werden kann, muss mit der IDE einfach nur die Datei frei3VideoDownloader.lpi geöffnet werden und unter dem Menüpunkt Start->Kompillieren die ausführbare Datei erzeugt werden.

### Installation

Das heruntergeladene Paket muss vollständig entpackt werden. Unter Windows muss sich FFMPEG im selben Ordner befinden wie die ausführbare Datei des frei3 Video-Downloaders. Unter Linux muss ffmpeg und das gnome-terminal über die Paketverwaltung installiert werden. 

### Anleitung

1. Im Eingabefeld im oberen Bereich die URL eines frei3-Beitrags (frei3 Videoquelle muss vorhanden sein!)  eingeben. Wahlweise auch nur die UUID angeben.
2. Nach einem klick auf "Prüfen", erscheinen die verfügbaren Streams. Bitte wähle einen der Streams.
3. Mit "Abspielen" wird das Video ohne zu Speichern abgespielt werden.
4. Mit "Speichern" kann die Auswahl als MP4-Datei gespeichert werden.

**Viel Spaß bei der Nutzung! Vorschläge gerne an meine Email im Programm unter "Info".**
