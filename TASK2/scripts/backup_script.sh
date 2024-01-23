# Set S3 bucket name and backup file name
S3_BUCKET="backup-pavlo-test-website"
BACKUP_FILE="backup-$(date +\%Y\%m\%d-\%H\%M\%S).tar.gz"

# Set Docker container name
CONTAINER_NAME="portfolio-container"

# Create a backup of the Docker container
sudo docker export -o "$BACKUP_FILE" "$CONTAINER_NAME" | gzip -f

# add the right permissions to the file
sudo chmod +r /home/ubuntu/$BACKUP_FILE

# Upload the backup file to S3
aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/$BACKUP_FILE"

# Remove the local backup file
sudo rm -f "$BACKUP_FILE"