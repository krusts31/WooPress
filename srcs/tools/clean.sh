docker exec $(docker ps | grep "srcs-wordpress" | awk '{print $1}')\
	/bin/sh -c '/usr/bin/wp post delete $(/usr/bin/wp post list\
	--post_type="page" --format=ids) --force'
docker exec $(docker ps | grep "srcs-wordpress" | awk '{print $1}') /bin/sh -c 'wp post delete $(wp post list --post_type="post" --format=ids) --force'
docker exec $(docker ps | grep "srcs-wordpress" | awk '{print $1}') /bin/sh -c 'wp comment delete $(wp comment list --format=ids) --force'
docker exec $(docker ps | grep "srcs-wordpress" | awk '{print $1}') /bin/sh -c 'wp theme delete $(wp theme list --status=inactive --field=name)'
docker exec $(docker ps | grep "srcs-wordpress" | awk '{print $1}') /bin/sh -c 'wp plugin delete $(wp plugin list --status=inactive --field=name)'
