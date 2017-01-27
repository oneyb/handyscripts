#!/bin/bash

dirs=/d
# d=Alternative_Rock
## Music
dir=${dirs}/music
pldir=${dir}/playlists
artdir=$pldir/artists
albdir=$pldir/albums
\rm -r $artdir/*m3u $albdir/*m3u

mkdir -p $pldir
mkdir -p $artdir
mkdir -p $albdir

file_formats='mp3|flac|og[agxmv]|wv|aac|mp[421a]|wav|aif[cf]?|m4[abpr]|ape|mk[av]|avi|mpf|vob|di?vx|mpga?|mov|flv|3gp|wm[av]|(m2)?ts|ac3'
genre=`ls ${dir} -I Playlists`
# echo $genre

## Genre playlists
for d in $genre
do
    # Genre playlists
    find ${dir}/${d} -type f | grep -E -i -e "(${file_formats})$" | sort > ${pldir}/${d}.m3u
    # Artist playlists
    artists=`find ${dir}/${d}/ -mindepth 1 -maxdepth 1 -type d`
    #"(${file_formats})$"`
    # echo $artists
    for a in ${artists}
    do
	      mkdir -p ${albdir}/`basename ${a}`
	      find ${a}/ -type f | grep -E -i -e "(${file_formats})$" | sort >> ${artdir}/`basename ${a}`.m3u
        # Artist playlists
	      albums=`find ${a}/ -mindepth 1 -maxdepth 1 -type d`
        #"(${file_formats})$"`
	      # echo $albums
	      for b in ${albums}
	      do
	          find ${b}/ -type f | grep -E -i -e "(${file_formats})$" | sort >> ${albdir}/`basename ${a}`/`basename ${b}`.m3u
	      done
    done
done

# All music
rm ${pldir}/all_music.m3u
cat ${pldir}/*.m3u > ${pldir}/all_music.m3u
