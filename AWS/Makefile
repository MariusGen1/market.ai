include .env

db-connect:
	mysql -u ${DB_USER} -h ${DB_HOST} --password=${DB_PASSWORD} ${DB_NAME}

reset-db:
	mysql -u ${DB_USER} -h ${DB_HOST} --password=${DB_PASSWORD} < Database/schema.sql

connect:
	ssh -i marius-rsa.pem ubuntu@${AWS_EIP}

make upload:
	rsync -avz --no-o --no-g -e "ssh -i marius-rsa.pem" ./* ubuntu@${AWS_EIP}:/home/ubuntu/
	scp -i marius-rsa.pem prod.env ubuntu@${AWS_EIP}:/home/ubuntu/.env

start:
	bash -c "while true; do node server.js; done"