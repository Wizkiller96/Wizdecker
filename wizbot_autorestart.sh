#!/bin/sh

if hash dotnet 2>/dev/null
then
	echo "Dotnet installed."
else
	echo "Dotnet is not installed. Please install dotnet."
	exit 1
fi

echo ""
echo "Linking WizBot Credentials"
mv -n /opt/WizBot/src/WizBot/credentials.json /root/wizbot/credentials.json > /dev/null 2>&1
rm /opt/WizBot/src/WizBot/credentials.json > /dev/null 2>&1
ln -s /root/wizbot/credentials.json /opt/WizBot/src/WizBot/credentials.json > /dev/null 2>&1

echo ""
echo "Patching WizBot Data Folder"
mkdir -p /root/wizbot/patch
cd /root/wizbot/patch && bash "./patch.sh"

echo ""
echo "Starting Redis-Server"
/usr/bin/redis-server --daemonize yes

echo ""
echo "Running WizBot with auto restart Please wait."
cd /opt/WizBot/src/WizBot
while :; do dotnet run -c Release --no-build; sleep 5s; done
echo "Done"

exit 0