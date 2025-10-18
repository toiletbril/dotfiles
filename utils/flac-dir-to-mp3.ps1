# place this file into directory with .flac files

dir *.flac | foreach {
        ffmpeg -i 
            $_.FullName 
            -ab 320k 
            -map_metadata 0 
            -id3v2_version 3 
            $_.FullName.Replace('flac', 'mp3')
    }
