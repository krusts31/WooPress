apt-get update && apt-get upgrade -y

# Install Nginx
apt-get install -y nginx

# Create necessary directories
mkdir -p /run/nginx
mkdir -p /etc/nginx/http.d

cp nginx.conf /etc/nginx/nginx.conf
cp dev.conf /etc/nginx/http.d/

systemctl start nginx
systemctl enable nginx
