#!/bin/bash
makiPath=node_modules/@mapbox/maki/icons/
shieldIconsPath=shield_icons/
outputDir=sprites
spriteZeroPath=node_modules/@mapbox/spritezero-cli/bin/spritezero
iconConfigPath=src/styles/

mkdir temp
mkdir ${outputDir}

source ~/.bash_profile
nvm use --delete-prefix v8.9.4

colorize () {
    iconName=$1
    fillColor=$2
    iconSetName=$3
    strokeColor=$4

	echo Colorizing ${iconName} to fill: ${fillColor} stroke: ${strokeColor} "for iconset" ${iconSetName}
	local path=temp/${iconSetName}/

    replaceWith="<path fill=\"${fillColor}\""
	if [ ! -z "$strokeColor" ]; then
        replaceWith="<path fill=\"${fillColor}\" stroke=\"${strokeColor}\" stroke-width=\".4\""
    fi


    # some of the maki svgs have fill in there. not sure if should replace style completley,
    # just going to replace exact for now since don't want to remove important things accidently
    sed -e "s/<path/${replaceWith}/;s/style=\"fill:#010101;\"//;" ${makiPath}${iconName}-11.svg > ${path}${iconName}-11.svg
    sed -e "s/<path/${replaceWith}/;s/style=\"fill:#010101;\"//;" ${makiPath}${iconName}-15.svg > ${path}${iconName}-15.svg

}

createIconSet () {
	cp -R ${makiPath} temp/$2
	cp -R ${shieldIconsPath} temp/$2

	while IFS=, read -r col1 col2 col3
	do
		colorize $col1 $col2 $2 $col3
	done < $1

	${spriteZeroPath} ${outputDir}/$2 temp/$2 --ratio=2
	${spriteZeroPath} ${outputDir}/$2@2x temp/$2  --ratio=4
}

createIconSet ${iconConfigPath}apollo-bright-icons.csv apollo-bright-icons
createIconSet ${iconConfigPath}zen-icons.csv zen-icons
createIconSet ${iconConfigPath}toner-icons.csv toner-icons

rm -rf temp
